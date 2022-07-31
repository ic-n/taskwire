import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskwire/assets.dart';
import 'package:taskwire/colors.dart';
import 'package:taskwire/components/title.dart';
import 'package:taskwire/components/twforms.dart';
import 'package:url_launcher/url_launcher.dart';

class PageAbout extends StatelessWidget {
  const PageAbout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageTitle(title: 'About'),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView(
            children: [
              const TWBox(
                body: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text(
                      'Authors',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  TWPara(paragraph: 'Developer: Nikola Kiselev\nUX: Daria Nosacheva'),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              TWBox(
                body: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text(
                      'Top patrons',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const TWPara(paragraph: 'v0: Yuriy, Eric and others'),
                  const SizedBox(
                    height: 20,
                  ),
                  TWButton(
                    lable: 'Donate',
                    color: reassurance,
                    callback: () {
                      launchUrl(Uri.parse('https://www.buymeacoffee.com/taskwire'));
                    },
                  )
                ],
              ),
            ],
          ),
        ),
        // Expanded(child: AllIcons())
      ],
    );
  }
}

class AllIcons extends StatelessWidget {
  const AllIcons({
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
