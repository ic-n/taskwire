import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskwire/assets.dart';
import 'package:taskwire/colors.dart';
import 'package:taskwire/components/title.dart';
import 'package:taskwire/components/tools.dart';
import 'package:taskwire/components/twforms.dart';
import 'package:taskwire/cubits/cubits.dart';
import 'package:url_launcher/url_launcher.dart';
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
        Tools(
          tools: [
            ToolsItem(
              iconPath: regularDocExport,
              label: 'Export',
              color: refreshing,
              onClick: () {},
            ),
            ToolsItem(
              iconPath: regularMugCode,
              label: 'Support project',
              color: refreshing,
              onClick: () {
                launchUrl(Uri.parse('https://www.buymeacoffee.com/taskwire'));
              },
            ),
          ],
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
              SettingsBox(
                body: [
                  Text('Set passcode'),
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
