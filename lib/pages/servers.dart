import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskwire/components/title.dart';

class PageServers extends StatelessWidget {
  const PageServers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: const [PageTitle(title: "Servers")],
        ));
  }
}
