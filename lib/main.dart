// import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:taskwire/taskwire/bindings.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taskwire/pages/jobs.dart';
import 'package:taskwire/pages/servers.dart';
import 'package:taskwire/pages/settings.dart';

void main() {
  runApp(const AppWrapper());
}

const refreshing = Color(0xFF62de84);
const reassurance = Color(0xFF31aa51);
const friendly = Color(0xFFffcb6b);
const confidence = Color(0xFFd9920d);
const authority = Color(0xFF75a1ff);
const intelegence = Color(0xFF1b5ff3);
const bg = Color(0x64292d3e);
const fgl = Color(0xFFfffefe);
const fg = Color(0xFFb0b2bd);

class AppWrapper extends StatelessWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.grey,
          cardColor: bg,
          backgroundColor: Colors.black,
          textTheme: const TextTheme(
              bodyText1: TextStyle(color: fg, fontFamily: 'JetBrainsMono'),
              bodyText2: TextStyle(color: fgl, fontFamily: 'JetBrainsMono'))),
      home: const Screen(screen: PageJobs()),
    );
  }
}

class Screen extends StatelessWidget {
  const Screen({
    Key? key,
    required this.screen,
  }) : super(key: key);

  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: screen,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                BarButton(
                  title: 'jobs',
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: const Screen(screen: PageJobs())));
                  },
                ),
                BarButton(
                  title: 'servers',
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: const Screen(screen: PageServers())));
                  },
                ),
                BarButton(
                  title: 'settings',
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: const Screen(screen: PageSettings())));
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: SvgPicture.asset(
                'assets/icons/logo/logo.svg',
                height: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarButton extends StatelessWidget {
  const BarButton({Key? key, required this.title, required this.onPressed})
      : super(key: key);

  final String title;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.hovered)) {
            return fgl;
          }
          return fg;
        }),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}
