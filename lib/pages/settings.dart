import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskwire/assets.dart';
import 'package:taskwire/components/title.dart';

class PageSettings extends StatelessWidget {
  const PageSettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> icons = [];
    for (var i in regular) {
      icons.add(
        Column(
          children: [
            SvgPicture.asset(
              i,
              color: Colors.white,
              height: 40,
            ),
            Text(i.split('/').last),
          ],
        ),
      );
    }
    return Column(
      children: [
        const PageTitle(title: 'Settings'),
        Expanded(
          child: GridView.count(
              controller: ScrollController(),
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 4,
              children: icons),
        ),
      ],
    );
  }
}
