import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:taskwire/ssh/connector.dart';

class Backend {
  void Function(Timer) progressFunc(void Function(double) progressCallback) {
    double time = 0;
    double progress = 0.1;

    return (t) {
      // Asymptote
      time += .001;
      progress = math.sqrt(1 - math.pow(time - 1, 2));

      if (progress < 1) {
        progressCallback(progress);
        return;
      }

      progressCallback(1);
      t.cancel();
    };
  }

  Future<String> sendCommand(String command, void Function(double) progressCallback) async {
    var t = Timer.periodic(const Duration(milliseconds: 10), progressFunc(progressCallback));

    return Future.delayed(
      const Duration(seconds: 9),
      () {
        progressCallback(1);
        t.cancel();
        String exec = command.split(" ")[0];
        return "command not found: $exec";
      },
    );
  }
}

class SSHBackend extends Backend {
  final String host;
  final int port;
  final String user;
  final String password;

  SSHBackend(this.host, this.port, this.user, this.password);

  @override
  Future<String> sendCommand(String command, void Function(double) progressCallback) async {
    var t = Timer.periodic(const Duration(milliseconds: 10), progressFunc(progressCallback));

    var client = await connectClient(host, port, user, password);
    var p = await client.run(command);

    progressCallback(1);
    t.cancel();

    return utf8.decode(p);
  }
}
