import 'package:dartssh2/dartssh2.dart';

Future<SSHClient> connectClient(String host, int port, String user, String password) async {
  var socket = await SSHSocket.connect(host, port);
  return SSHClient(
    socket,
    username: user,
    onPasswordRequest: () => password,
  );
}
