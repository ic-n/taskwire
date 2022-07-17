import 'package:dartssh2/dartssh2.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:taskwire/ssh/connector.dart';

Map<String, Color> colorMap = {
  '30': Colors.grey.shade500,
  '31': Colors.red,
  '32': Colors.green,
  '33': Colors.yellow,
  '34': Colors.blue,
  '35': Colors.purple.shade300,
  '36': Colors.cyan,
  '37': Colors.white,
  '30;1': Colors.grey.shade400,
  '31;1': Colors.red.shade400,
  '32;1': Colors.green.shade400,
  '33;1': Colors.yellow.shade400,
  '34;1': Colors.blue.shade400,
  '35;1': Colors.purple.shade200,
  '36;1': Colors.cyan.shade400,
  '37;1': Colors.white,
  '0;30': Colors.black,
  '1;30': Colors.grey,
  '0;31': Colors.red,
  '1;31': Colors.red.shade300,
  '0;32': Colors.green,
  '1;32': Colors.green.shade300,
  '0;33': Colors.brown,
  '1;33': Colors.yellow,
  '0;34': Colors.blue,
  '1;34': Colors.blue.shade300,
  '0;35': Colors.purple,
  '1;35': Colors.purple.shade300,
  '0;36': Colors.cyan,
  '1;36': Colors.cyan.shade300,
  '0;37': Colors.grey.shade300,
  '1;37': Colors.white,
  '0': Colors.white,
};

class OutputToken extends Equatable {
  const OutputToken(this.content, this.color);

  final String content;
  final Color color;

  @override
  List<Object> get props => [content, color];
}

class OutputTokens extends Equatable {
  const OutputTokens(this.tokens);

  final List<OutputToken> tokens;

  @override
  List<Object> get props => tokens;
}

class Execution extends Equatable {
  const Execution(this.cmd, this.tokens, [this.exitCode, this.ctrlC]);

  final String cmd;
  final OutputTokens tokens;
  final int? exitCode;
  final void Function()? ctrlC;

  @override
  List<Object> get props => [tokens];
}

class Term extends Equatable {
  const Term(this.executions);

  final List<Execution> executions;

  @override
  List<Object> get props => [executions];
}

class LiveTerminalCubit extends Cubit<Term> {
  LiveTerminalCubit() : super(const Term([]));

  SSHClient? client;

  void connect(String host, int port, String user, String password) {
    if (client == null) {
      connectClient(host, port, user, password).then((c) => client = c);
    }
  }

  void sendCommand(String cmd, void Function()? scrollDown, void Function(List<OutputToken>)? listen,
      void Function(void Function()) killerCallback) {
    if (client != null) {
      client!.execute(cmd).then((value) {
        List<OutputToken> tokens = [];
        Color cur = Colors.white;

        Timer? t;

        if (listen != null) {
          t = Timer.periodic(
            const Duration(milliseconds: 100),
            (_) {
              listen(tokens);
            },
          );
        }

        killerCallback(() {
          if (t != null) {
            t.cancel();
          }
          value.kill(SSHSignal.TERM);
          emit(Term([
            ...state.executions,
            Execution(cmd, OutputTokens(tokens), 143),
          ]));
          if (scrollDown != null) {
            scrollDown();
          }
        });

        value.stdout.cast<List<int>>().transform(utf8.decoder).transform(const LineSplitter()).listen((line) {
          Iterable<Match> matches = asciColors(line);
          int offset = 0;
          for (final Match m in matches) {
            tokens.add(OutputToken(line.substring(offset, m.start), cur));
            offset = m.end;
            cur = getColor(m);
          }
          tokens.add(OutputToken('${line.substring(offset)}\n', cur));
        });

        value.done.then((_) {
          if (t != null) {
            t.cancel();
          }
          if (value.exitCode != null) {
            emit(Term([
              ...state.executions,
              Execution(cmd, OutputTokens(tokens), value.exitCode!),
            ]));
          }
          if (scrollDown != null) {
            scrollDown();
          }
        });
      });
    }
  }

  Iterable<Match> asciColors(String line) {
    var re = RegExp(r'(\x9B|\x1B\[)([0-?]*)([ -\/]*)([@-~])', caseSensitive: false, multiLine: false);
    Iterable<Match> matches = re.allMatches(line);
    return matches;
  }

  Color getColor(Match m) {
    Color cur = Colors.white;
    String? v = m.group(2);
    if (v != null && v != '0') {
      Color? colorCode = colorMap[v];
      if (colorCode != null) {
        cur = colorCode;
      }
    }
    return cur;
  }
}
