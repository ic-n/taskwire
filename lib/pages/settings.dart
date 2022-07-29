import 'package:flutter/material.dart';
import 'package:taskwire/colors.dart';
import 'package:taskwire/components/title.dart';
import 'package:taskwire/components/twforms.dart';
import 'package:taskwire/cubits/cubits.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageSettings extends StatelessWidget {
  const PageSettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageTitle(title: 'Settings'),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView(
            children: [
              SettingsBox(
                body: [
                  TWField(
                    title: 'Set app passcode',
                    hint: 'passcode that you will write on each app start',
                    initialValue: '',
                    color: reassurance,
                    callback: (s) {
                      context.read<PasscodeCubit>().newPasscode(s);
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

class SettingsBox extends StatelessWidget {
  const SettingsBox({
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
