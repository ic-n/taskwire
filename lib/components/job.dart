import 'package:flutter/material.dart';
import 'package:taskwire/backend/backend.dart';
import 'package:taskwire/components/steps.dart';

class StepData {
  StepData({
    required this.status,
    required this.command,
    required this.out,
    this.progress = 0,
  });

  double progress = 0;
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
  List<StepData> steps = [
    StepData(status: false, progress: 0, command: "sudo apt update -y", out: ""),
    StepData(status: false, progress: 0, command: "sudo apt upgade -y docker", out: ""),
    StepData(status: false, progress: 0, command: "test -f /var/run/docker.sock", out: ""),
  ];
  bool endStep = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> timeline = [];
    for (var i = 0; i < steps.length; i++) {
      timeline.add(CommandStep(
          status: steps[i].status,
          fn: () {
            var newStep = steps[i];
            if (!newStep.status) {
              widget.backend.sendCommand(newStep.command, (prog) {
                setState(() {
                  newStep.progress = prog;
                  steps[i] = newStep;
                });
              }).then((value) {
                setState(() {
                  newStep.out = value;
                  newStep.status = true;
                  newStep.progress = 1;
                  steps[i] = newStep;
                });
              });
              newStep.out = "...";
              newStep.status = false;
              newStep.progress = 0;
            } else {
              newStep.out = "";
              newStep.status = false;
              newStep.progress = 0;
            }
            setState(() {
              steps[i] = newStep;
            });
          },
          progress: steps[i].progress,
          command: steps[i].command,
          out: steps[i].out));
    }

    timeline.add(EndStep(status: steps[steps.length - 1].status));

    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: timeline,
        ),
      ],
    );
  }
}
