import 'package:flutter/material.dart';
import 'package:taskwire/colors.dart';
import 'package:taskwire/components/title.dart';
import 'package:taskwire/components/twforms.dart';
import 'package:taskwire/cubits/cubits.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskwire/main.dart';

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
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 10,
                    runSpacing: 20,
                    children: [
                      TWButton(
                        lable: 'Reset tasks',
                        callback: () {
                          context.read<JobCardsCubit>().reset();
                          context.read<CurrentJobCubit>().reset();
                        },
                        color: bgl,
                      ),
                      TWButton(
                        lable: 'Reset servers connections',
                        callback: () {
                          context.read<MachinesCubit>().reset();
                        },
                        color: bgl,
                      ),
                      TWButton(
                        lable: 'Reset application',
                        callback: () {
                          storage?.clear();
                          context.read<JobCardsCubit>().reset();
                          context.read<CurrentJobCubit>().reset();
                          context.read<MachinesCubit>().reset();
                          context.read<PasscodeCubit>().reset();
                        },
                        color: bgl,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
