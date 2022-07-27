import 'dart:core';
import 'package:dartssh2/dartssh2.dart';

Future<SSHClient> connectClientWithPassword(String host, int port, String user, String password) async {
  var socket = await SSHSocket.connect(host, port);
  return SSHClient(
    socket,
    username: user,
    onPasswordRequest: () => password,
  );
}

Future<SSHClient> connectClient(String host, int port, String user, String sshKey, String passphrase) async {
  var socket = await SSHSocket.connect(host, port);
  return SSHClient(
    socket,
    username: user,
    identities: await newPc(sshKey, passphrase),
  );
}

Future<List<SSHKeyPair>> newPc(String sshKey, String passphrase) async {
  return SSHKeyPair.fromPem(sshKey, passphrase);
}
