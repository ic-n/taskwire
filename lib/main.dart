import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:taskwire/taskwire/bindings.dart';

void main() {
  runApp(const AppWrapper());
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String _cmd = "echo tset123";
  String _out = "...";

  void typeCommand(String cmd) {
    setState(() {
      _cmd = cmd;
    });
  }

  void displayOutput(String out) {
    setState(() {
      _out = out;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            onChanged: (value) => typeCommand(value),
          ),
          ElevatedButton(
            onPressed: () {
              displayOutput(
                  singleCall('root', 'taskwire', '127.0.0.1:2222', _cmd));
            },
            child: const Text("Execute"),
          ),
          Text(_out),
        ],
      ),
      appBar: AppBar(),
    );
  }
}
