import 'package:flutter/material.dart';
import 'package:taskwire/components/title.dart';

class PageSettings extends StatelessWidget {
  const PageSettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: const [PageTitle(title: "Settings")],
        ));
  }
}
