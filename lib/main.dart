import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taskwire/colors.dart';
import 'package:taskwire/cubits/cubits.dart';
import 'package:taskwire/cubits/liveterm.dart';
import 'package:taskwire/pages/jobs.dart';
import 'package:taskwire/pages/servers.dart';
import 'package:taskwire/pages/settings.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<JobCardsCubit>(create: (context) => JobCardsCubit()),
      BlocProvider<CurrentJobCubit>(create: (context) => CurrentJobCubit()),
      BlocProvider<LiveTerminalCubit>(create: (context) => LiveTerminalCubit())
    ],
    child: const AppWrapper(),
  ));
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
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
                    Navigator.push(context,
                        PageTransition<Screen>(type: PageTransitionType.fade, child: const Screen(screen: PageJobs())));
                  },
                ),
                BarButton(
                  title: 'servers',
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition<Screen>(
                            type: PageTransitionType.fade, child: const Screen(screen: PageServers())));
                  },
                ),
                BarButton(
                  title: 'settings',
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition<Screen>(
                            type: PageTransitionType.fade, child: const Screen(screen: PageSettings())));
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
  const BarButton({Key? key, required this.title, required this.onPressed}) : super(key: key);

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
