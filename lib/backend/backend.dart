import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:dartssh2/dartssh2.dart';
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

  Future<String> sendCommand(String command, [void Function(double)? progressCallback]) async {
    Timer? t;

    if (progressCallback != null) {
      t = Timer.periodic(const Duration(milliseconds: 10), progressFunc(progressCallback));
    }

    return Future.delayed(
      const Duration(seconds: 9),
      () {
        if (progressCallback != null) {
          progressCallback(1);
        }
        t?.cancel();
        String exec = command.split(' ')[0];
        return 'command not found: $exec';
      },
    );
  }

  Future<String> getGoos() async {
    String output = await sendCommand("uname -s | tr '[:upper:]' '[:lower:]'");
    output = output.trim();

    if (output.contains('cygwin_nt')) {
      return 'windows';
    }
    if (output.contains('mingw')) {
      return 'windows';
    }
    if (output.contains('msys_nt')) {
      return 'windows';
    }

    return output;
  }

  Future<String> getGoarch() async {
    String output = await sendCommand('uname -m');
    output = output.trim();
    switch (output) {
      case 'x86_64':
        return 'amd64_v1';
      case 'x86':
        return '386';
      case 'i686':
        return '386';
      case 'i386':
        return '386';
      case 'aarch64':
        return 'arm64';
      default:
        if (output.contains('armv5')) {
          return 'armv5';
        }
        if (output.contains('armv6')) {
          return 'armv6';
        }
        if (output.contains('armv7')) {
          return 'armv7';
        }

        throw Exception('unknown arch: $output');
    }
  }

  Future<void> keyExchange(String passcode) async {}
}

class SSHBackend extends Backend {
  final String host;
  final int port;
  final String user;
  final String password;

  SSHClient? client;

  SSHBackend(this.host, this.port, this.user, this.password);

  Future<void> ensureClient() async {
    client ??= await connectClientWithPassword(host, port, user, password);
  }

  @override
  Future<String> sendCommand(String command, [void Function(double)? progressCallback]) async {
    Timer? t;

    if (progressCallback != null) {
      t = Timer.periodic(const Duration(milliseconds: 10), progressFunc(progressCallback));
    }

    try {
      await ensureClient();
    } on Exception catch (e) {
      return 'connection issue ${e.toString()}';
    }

    var p = await client!.run(command);

    if (progressCallback != null) {
      progressCallback(1);
      t?.cancel();
    }

    return utf8.decode(p);
  }

  @override
  Future<String> keyExchange(String passcode) async {
    await ensureClient();

    final goos = await getGoos();
    final goarch = await getGoarch();

    final file = File('keyexchange/taskwire_${goos}_$goarch/taskwire');

    final transport = await client!.sftp();

    String fn = '/tmp/taskwire_keyexchangev1';

    await transport.open(fn, mode: SftpFileOpenMode.create);
    final keyex = await transport.open(fn, mode: SftpFileOpenMode.write);

    keyex.writeBytes(await file.readAsBytes());

    await keyex.close();

    await client!.run('chmod +x $fn');
    final output = await client!.run('$fn $passcode');
    final keys = utf8.decode(output).split('-----');
    final priv = keys[2].trim();
    // final pub = keys[6].trim();

    return priv;
  }
}
