import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskwire/backend/backend.dart';
import 'package:taskwire/components/steps.dart';
import 'package:taskwire/components/tools.dart';
import 'package:taskwire/cubits/cubits.dart';

class JobWidget extends StatelessWidget {
  const JobWidget({
    Key? key,
    required this.backend,
  }) : super(key: key);

  final SSHBackend backend;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentJobCubit, Job>(builder: (context, state) {
      if (state.steps.isEmpty) {
        return const Opacity(opacity: 0.5, child: Text("nothing selected"));
      }

      List<Widget> timeline = [];
      for (var i = 0; i < state.steps.length; i++) {
        timeline.add(CommandStep(
            status: state.steps[i].status,
            fn: () {
              context.read<CurrentJobCubit>().resetStep(i);
              runStepCommand(context, state.steps, i);
            },
            progress: state.steps[i].progress,
            command: state.steps[i].command,
            out: state.steps[i].out));
      }

      timeline.add(EndStep(status: state.steps[state.steps.length - 1].status));

      return Tools(
        tools: [
          ToolsItem(
            iconPath: "assets/icons/yellow/streamlinehq-interface-arrows-right-circle-interface-essential-48.SVG",
            label: "Run all",
            onClick: () {
              context.read<CurrentJobCubit>().resetRuns();

              int stepIndex = 0;
              void Function()? recursiveRun;

              recursiveRun = () {
                if (stepIndex >= state.steps.length) {
                  return;
                }
                runStepCommand(context, state.steps, stepIndex, recursiveRun);
                stepIndex++;
              };

              recursiveRun();
            },
          )
        ],
        child: ListView(
          controller: ScrollController(),
          children: timeline,
        ),
      );
    });
  }

  void runStepCommand(BuildContext context, List<StepData> steps, int stepIndex, [void Function()? callback]) {
    backend.sendCommand(steps[stepIndex].command, (prog) {
      var newStep = steps[stepIndex];
      newStep.progress = prog;
      context.read<CurrentJobCubit>().updateStep(stepIndex, newStep);
    }).then((value) {
      var newStep = steps[stepIndex];
      newStep.out = value;
      newStep.status = true;
      newStep.progress = 1;
      context.read<CurrentJobCubit>().updateStep(stepIndex, newStep);
      if (callback != null) {
        callback();
      }
    });
  }
}
