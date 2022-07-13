import 'package:flutter/material.dart';
import 'package:taskwire/components/title.dart';
import 'package:taskwire/ssh/ssh.dart';

class PageServers extends StatelessWidget {
  const PageServers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        PageTitle(title: 'Servers'),
        SizedBox(
          height: 12,
        ),
        SSHTerm(
          host: 'localhost',
          port: 2222,
          user: 'root',
          password: 'taskwire',
        )
      ],
    );
  }
}
