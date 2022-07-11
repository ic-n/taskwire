import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskwire/backend/backend.dart';
import 'package:taskwire/components/steps.dart';
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
        return const Text("...");
      }
      List<Widget> timeline = [];
      for (var i = 0; i < state.steps.length; i++) {
        timeline.add(CommandStep(
            status: state.steps[i].status,
            fn: () {
              context.read<CurrentJobCubit>().updateStep(i, onClick(context, state.steps, i));
            },
            progress: state.steps[i].progress,
            command: state.steps[i].command,
            out: state.steps[i].out));
      }

      timeline.add(EndStep(status: state.steps[state.steps.length - 1].status));

      return Expanded(
        child: ListView(
          controller: ScrollController(),
          children: timeline,
        ),
      );
    });
  }

  StepData onClick(BuildContext context, List<StepData> steps, int i) {
    var newStep = steps[i];
    if (!newStep.status) {
      backend.sendCommand(newStep.command, (prog) {
        var newStep = steps[i];
        newStep.progress = prog;
        context.read<CurrentJobCubit>().updateStep(i, newStep);
      }).then((value) {
        var newStep = steps[i];
        newStep.out = value;
        newStep.status = true;
        newStep.progress = 1;
        context.read<CurrentJobCubit>().updateStep(i, newStep);
      });
      newStep.out = "...";
      newStep.status = false;
      newStep.progress = 0;
    } else {
      newStep.out = "";
      newStep.status = false;
      newStep.progress = 0;
    }
    return newStep;
  }
}
