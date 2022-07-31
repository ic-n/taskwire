import 'package:flutter/material.dart';
import 'package:taskwire/components/task.dart';
import 'package:taskwire/components/tasks.dart';
import 'package:taskwire/components/title.dart';

class PageJobs extends StatelessWidget {
  const PageJobs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Flexible(
        flex: 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            PageTitle(title: 'Jobs'),
            JobsWidget(),
          ],
        ),
      ),
      const SizedBox(
        width: 40,
      ),
      Flexible(
        flex: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            PageTitle(title: 'Job'),
            JobWidget(),
          ],
        ),
      )
    ]);
  }
}
