import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taskwire/components/tools.dart';
import 'package:taskwire/cubits/cubits.dart';
import 'package:taskwire/main.dart';
import 'package:taskwire/pages/newtask.dart';

class JobsWidget extends StatelessWidget {
  const JobsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobCardsCubit, JobCards>(builder: (context, state) {
      List<Tile> tiles = [];
      for (var jobIndex = 0; jobIndex < state.cards.length; jobIndex++) {
        var jobCard = state.cards[jobIndex];
        String body = "";
        for (var step in jobCard.steps) {
          body += "${step.command}; ";
        }
        tiles.add(Tile(
            title: jobCard.title,
            body: body,
            path: "assets/icons/yellow/streamlinehq-interface-arrows-right-circle-interface-essential-48.SVG",
            onSecond: () {
              context.read<CurrentJobCubit>().steps(jobCard.steps);
              context.read<JobCardsCubit>().setCurrentEdit(JobCard(jobCard.title, jobCard.steps, jobIndex));
              Navigator.push(context,
                  PageTransition<Screen>(type: PageTransitionType.fade, child: const Screen(screen: PageNewTask())));
            },
            onMain: () {
              context.read<CurrentJobCubit>().steps(jobCard.steps);
            }));
      }
      return Tools(
          tools: [
            ToolsItem(
              iconPath: "assets/icons/yellow/streamlinehq-interface-add-circle-interface-essential-48.SVG",
              label: "Add new task",
              onClick: () {
                context.read<CurrentJobCubit>().steps([]);
                Navigator.push(context,
                    PageTransition<Screen>(type: PageTransitionType.fade, child: const Screen(screen: PageNewTask())));
              },
            ),
          ],
          child: GridView.count(
              controller: ScrollController(),
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2,
              children: tiles));
    });
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.title,
    required this.path,
    required this.onMain,
    required this.onSecond,
    required this.body,
  }) : super(key: key);

  final String title;
  final String path;
  final Null Function() onMain;
  final Null Function() onSecond;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onSecond,
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              TextButton(
                  onPressed: (onMain),
                  style: TextButton.styleFrom(
                      minimumSize: const Size(10, 30),
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerRight),
                  child: SvgPicture.asset(
                    path,
                    height: 40,
                  ))
            ],
          ),
          GestureDetector(
            onTap: onSecond,
            child: Opacity(
              opacity: 0.5,
              child: Text(
                body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
