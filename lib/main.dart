import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taskwire/colors.dart';
import 'package:taskwire/components/twforms.dart';
import 'package:taskwire/cubits/cubits.dart';
import 'package:taskwire/pages/about.dart';
import 'package:taskwire/pages/jobs.dart';
import 'package:taskwire/pages/servers.dart';
import 'package:taskwire/pages/settings.dart';

HydratedStorage? storage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var app = MultiBlocProvider(
    providers: [
      BlocProvider<JobCardsCubit>(create: (context) => JobCardsCubit()),
      BlocProvider<CurrentJobCubit>(create: (context) => CurrentJobCubit()),
      BlocProvider<MachinesCubit>(create: (context) => MachinesCubit()),
      BlocProvider<PasscodeCubit>(create: (context) => PasscodeCubit()),
    ],
    child: const AppWrapper(),
  );

  storage = await HydratedStorage.build(
    storageDirectory: await getApplicationSupportDirectory(),
  );

  HydratedBlocOverrides.runZoned(
    () => runApp(app),
    storage: storage,
  );
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskwire',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          buttonTheme: const ButtonThemeData(
            alignedDropdown: true,
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.hovered)) {
                  return fgl;
                }
                return fg;
              }),
              splashFactory: NoSplash.splashFactory,
            ),
          ),
          useMaterial3: true,
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
    return BlocBuilder<PasscodeCubit, Passcode>(
      builder: (context, state) {
        var appOk = state.appHasPasscode();

        final Widget codeInput;

        if (!state.appHasPasscodeHash()) {
          codeInput = Welcome(state);
        } else {
          codeInput = PinPad(state);
        }

        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: appOk
              ? Padding(
                  padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
                  child: screen,
                )
              : codeInput,
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: bgd,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: !appOk
                      ? [
                          BarButton(
                            title: '',
                            onPressed: () {},
                          )
                        ]
                      : [
                          BarButton(
                            title: 'jobs',
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition<Screen>(
                                      type: PageTransitionType.fade, child: const Screen(screen: PageJobs())));
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
                          // BarButton(
                          //   title: 'about',
                          //   onPressed: () {
                          //     Navigator.push(
                          //         context,
                          //         PageTransition<Screen>(
                          //             type: PageTransitionType.fade, child: const Screen(screen: PageAbout())));
                          //   },
                          // ),
                        ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 1, left: 20),
                  child: SvgPicture.asset(
                    'assets/icons/logo/logo.svg',
                    height: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PinPad extends StatelessWidget {
  const PinPad(
    this.state, {
    Key? key,
  }) : super(key: key);

  final Passcode state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TWPasswordField(
            title: 'Unlock application with passcode',
            hint: 'passcode',
            initialValue: '',
            color: authority,
            callback: (code) {
              if (state.checkPasscode(code)) {
                Timer(const Duration(milliseconds: 100), () {
                  context.read<PasscodeCubit>().savePasscode(code);
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

class Welcome extends StatefulWidget {
  const Welcome(
    this.state, {
    Key? key,
  }) : super(key: key);

  final Passcode state;

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  String code = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "-> Welcome to taskwire.",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "-> That's an new application SSH client, with perspective future. Which you part of!",
            style: TextStyle(color: fg, fontSize: 14),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Remember this code, it will be used each time you open app, on SSH key exchange as key passcode.",
            style: TextStyle(color: bgxl, fontSize: 12),
          ),
          const SizedBox(
            height: 100,
          ),
          TWField(
            title: 'Create new passcode',
            hint: 'passcode',
            initialValue: '',
            color: authority,
            callback: (newCode) {
              setState(() {
                code = newCode;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TWButton(
            lable: "Save",
            callback: () => context.read<PasscodeCubit>().newPasscode(code),
            color: authority,
          ),
        ],
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
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}
