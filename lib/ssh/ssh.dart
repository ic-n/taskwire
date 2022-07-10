import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:core';
import 'package:dartssh2/dartssh2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:equatable/equatable.dart';
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

class Terminal extends Cubit<Term> {
  Terminal() : super(const Term([]));

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
          tokens.add(OutputToken("${line.substring(offset)}\n", cur));
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
    var re = RegExp(r"(\x9B|\x1B\[)([0-?]*)([ -\/]*)([@-~])", caseSensitive: false, multiLine: false);
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

class SSHTerm extends StatefulWidget {
  const SSHTerm({
    Key? key,
    required this.host,
    required this.port,
    required this.user,
    required this.password,
  }) : super(key: key);

  final String host;
  final int port;
  final String user;
  final String password;

  @override
  State<SSHTerm> createState() => _SSHTermState();
}

class _SSHTermState extends State<SSHTerm> {
  String cmd = "";
  List<OutputToken> tokens = [];
  void Function()? killer;

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var t = Terminal();
    t.connect(widget.host, widget.port, widget.user, widget.password);

    return BlocProvider(
        create: (context) => t,
        child: BlocBuilder<Terminal, Term>(builder: (context, state) {
          List<Widget> lines = [];

          for (var executions in state.executions) {
            List<TextSpan> textLines = [];

            lines.add(Text(
              '-> ${executions.cmd} (${executions.exitCode})',
              style: Theme.of(context).textTheme.bodyText1,
            ));

            for (var token in executions.tokens.tokens) {
              textLines.add(TextSpan(
                text: token.content,
                style: TextStyle(color: token.color),
              ));
            }

            lines.add(RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: textLines,
              ),
            ));
          }

          if (killer != null) {
            lines.add(Text(
              '-> $cmd',
              style: Theme.of(context).textTheme.bodyText1,
            ));

            List<TextSpan> textLines = [];
            for (var token in tokens) {
              textLines.add(TextSpan(
                text: token.content,
                style: TextStyle(color: token.color),
              ));

              lines.add(RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: textLines,
                ),
              ));
            }

            lines.add(Row(
              children: [
                TextButton(
                  onPressed: killer,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.white;
                      }
                      return Colors.white.withAlpha(50);
                    }),
                  ),
                  child: Text(
                    "stop it",
                    style: Theme.of(context).textTheme.bodyText2?.merge(const TextStyle(color: Colors.black)),
                  ),
                )
              ],
            ));
          }

          lines.add(Container(
            constraints: const BoxConstraints(minWidth: 50),
            child: TextFormField(
              onFieldSubmitted: (value) {
                context.read<Terminal>().sendCommand(cmd, () {
                  setState(() {
                    killer = null;
                    tokens = [];
                  });
                  Future.delayed(const Duration(milliseconds: 250), () {
                    _controller.animateTo(_controller.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                  });
                }, (toks) {
                  setState(() {
                    tokens = toks;
                    _controller.animateTo(_controller.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
                  });
                }, (k) {
                  setState(() {
                    killer = k;
                  });
                });
              },
              onChanged: (value) {
                setState(() {
                  cmd = value;
                });
              },
              style: const TextStyle(color: Colors.white),
              enabled: (killer == null),
              decoration: const InputDecoration(
                  isDense: true,
                  prefixIcon: Text("\$ "),
                  prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none),
            ),
          ));
          return Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 100),
            child: ListView(
              controller: _controller,
              children: lines,
            ),
          );
        }));
  }
}
