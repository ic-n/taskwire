import 'package:flutter/material.dart';
import 'package:taskwire/backend/backend.dart';
import 'package:taskwire/components/line.dart';
import 'package:taskwire/components/steps.dart';

class StepData {
  StepData({
    required this.status,
    required this.command,
    required this.out,
  });

  bool status;
  String command;
  String out;
}

class JobWidget extends StatefulWidget {
  const JobWidget({
    Key? key,
    required this.backend,
  }) : super(key: key);

  final Backend backend;

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  double progress = 0.5;
  List<StepData> steps = []; //todo
  bool endStep = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> timeline = [];
    for (var i = 0; i < steps.length; i++) {
      CommandStep(
          status: steps[i].status,
          fn: () {
            setState(() {
              var newStep = steps[i];
              newStep.status = !newStep.status;
              steps[i] = newStep;
            });
          },
          command: steps[i].command,
          out: steps[i].out);
    }

    timeline.add(EndStep(status: endStep));

    return Row(
      children: [
        CustomPaint(
          painter: LoadingLine(progress: progress),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: timeline,
          ),
        ),
      ],
    );
  }
}
