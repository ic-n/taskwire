import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taskwire/assets.dart';
import 'package:taskwire/colors.dart';
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
        var t = jobCard.touched;
        tiles.add(Tile(
          title: jobCard.title,
          time: '${t.day}.${t.month} ${t.hour}:${t.minute}',
          buttons: [
            TileButton(
              buttonIcon: regularEdit,
              action: () {
                context.read<CurrentJobCubit>().steps(jobCard.steps);
                context
                    .read<JobCardsCubit>()
                    .setCurrentEdit(JobCard(jobCard.title, jobCard.steps, DateTime.now(), jobIndex));
                Navigator.push(context,
                    PageTransition<Screen>(type: PageTransitionType.fade, child: const Screen(screen: PageNewTask())));
              },
            ),
            TileButton(
              buttonIcon: regularArrowRight,
              action: () {
                context.read<CurrentJobCubit>().steps(jobCard.steps);
              },
            )
          ],
        ));
      }
      var queryData = MediaQuery.of(context);
      return Tools(
          tools: [
            ToolsItem(
              iconPath: regularFilePlus,
              label: 'Add new task',
              onClick: () {
                context.read<CurrentJobCubit>().steps([]);
                Navigator.push(context,
                    PageTransition<Screen>(type: PageTransitionType.fade, child: const Screen(screen: PageNewTask())));
              },
            ),
          ],
          child: GridView.count(
              controller: ScrollController(),
              crossAxisCount: ((queryData.size.width - 200) / 600).ceil(),
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
    required this.time,
    required this.buttons,
  }) : super(key: key);

  final String title;
  final String time;
  final List<TileButton> buttons;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: bg,
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: bgl,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text(
                      time,
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(color: bgxl),
                    ),
                    const Spacer(),
                    ...buttons,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TileButton extends StatelessWidget {
  const TileButton({
    Key? key,
    required this.action,
    required this.buttonIcon,
  }) : super(key: key);

  final Null Function() action;
  final String buttonIcon;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: action,
      style: TextButton.styleFrom(
          minimumSize: const Size(10, 30),
          shape: const CircleBorder(),
          padding: EdgeInsets.zero,
          alignment: Alignment.centerRight),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: SvgPicture.asset(
          buttonIcon,
          color: friendly,
          height: 20,
        ),
      ),
    );
  }
}
