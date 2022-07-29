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
              const AboutBox(
                body: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text(
                      'Authors',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Para(paragraph: 'Developer: Nikola Kiselev\nUX: Daria Nosacheva'),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              AboutBox(
                body: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text(
                      'Top patrons',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const Para(paragraph: 'v0: Yuriy, Eric and others'),
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
        )
      ],
    );
  }
}

class Para extends StatelessWidget {
  const Para({
    Key? key,
    required this.paragraph,
  }) : super(key: key);

  final String paragraph;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(paragraph),
    );
  }
}

class AboutBox extends StatelessWidget {
  const AboutBox({
    Key? key,
    required this.body,
  }) : super(key: key);

  final List<Widget> body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: bgd,
        ),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: body,
          ),
        ),
      ),
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
