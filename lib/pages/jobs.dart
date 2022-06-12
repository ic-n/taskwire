import 'package:flutter/material.dart';
import 'package:taskwire/backend/backend.dart';
import 'package:taskwire/components/job.dart';
import 'package:taskwire/components/jobs.dart';
import 'package:taskwire/components/title.dart';

class PageJobs extends StatelessWidget {
  const PageJobs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              PageTitle(title: "Jobs"),
              SizedBox(
                height: 12,
              ),
              JobsWidget(),
            ],
          ),
        ),
      ),
      Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageTitle(title: "Job"),
              const SizedBox(
                height: 12,
              ),
              JobWidget(backend: Backend(),),
            ],
          ),
        ),
      )
    ]);
  }
}
