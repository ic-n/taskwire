import 'dart:async';
import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'dart:core';

import 'package:taskwire/cubits/cubits.dart';
import 'package:taskwire/ssh/connector.dart';
import 'package:xterm/flutter.dart';
import 'package:xterm/terminal/terminal.dart';
import 'package:xterm/terminal/terminal_backend.dart';
import 'package:xterm/theme/terminal_theme.dart';

class SSHTerm extends StatefulWidget {
  const SSHTerm({
    Key? key,
    required this.machine,
    required this.passcode,
  }) : super(key: key);

  final Machine machine;
  final String passcode;

  @override
  State<SSHTerm> createState() => _SSHTermState();
}

class Shell extends TerminalBackend {
  Shell(this.sh);

  SSHSession sh;

  final _exitCodeCompleter = Completer<int>();
  final _outStream = StreamController<String>();

  @override
  Future<int> get exitCode => _exitCodeCompleter.future;

  @override
  void init() {
    sh.stdout.listen((data) => _outStream.sink.add(String.fromCharCodes(data)));
  }

  @override
  Stream<String> get out => _outStream.stream;

  @override
  void resize(int width, int height, int pixelWidth, int pixelHeight) {
    sh.resizeTerminal(width, height);
  }

  @override
  void write(String input) {
    sh.write(const Utf8Encoder().convert(input));
  }

  @override
  void terminate() {
    sh.close();
  }

  @override
  void ackProcessed() {
    // NOOP
  }
}

class _SSHTermState extends State<SSHTerm> {
  Shell? backend;

  @override
  void initState() {
    createClient();
    super.initState();
  }

  Future<void> createClient() async {
    var newClient = await connectClient(
      widget.machine.host,
      widget.machine.port,
      widget.machine.user,
      widget.machine.rsa,
      widget.passcode,
    );
    var newSh = await newClient.shell();
    setState(() {
      backend = Shell(newSh);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (backend == null) {
      return const Text('connecting...');
    }
    var terminal = Terminal(
        backend: backend,
        maxLines: 10000,
        theme: const TerminalTheme(
          cursor: 0XFF292d3e,
          selection: 0XFF292d3e,
          foreground: 0XFFb0b2bd,
          background: 0XFF15161f,
          black: 0XFF414562,
          red: 0XFFf07178,
          green: 0XFF62de84,
          yellow: 0XFFffcb6b,
          blue: 0XFF75a1ff,
          magenta: 0XFFf580ff,
          cyan: 0XFF60baec,
          white: 0XFFb0b2bd,
          brightBlack: 0XFF4a5270,
          brightRed: 0XFFf07178,
          brightGreen: 0XFFc3e88d,
          brightYellow: 0XFFffcb6b,
          brightBlue: 0XFF82aaff,
          brightMagenta: 0XFFff5572,
          brightCyan: 0XFF959dcb,
          brightWhite: 0XFFfffefe,
          searchHitBackground: 0XFF676e95,
          searchHitBackgroundCurrent: 0XFFabb2bf,
          searchHitForeground: 0XFFfffefe,
        ));
    return TerminalView(
      terminal: terminal,
    );
  }
}
