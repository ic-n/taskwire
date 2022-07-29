import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskwire/assets.dart';
import 'package:taskwire/backend/backend.dart';
import 'package:taskwire/colors.dart';
import 'package:taskwire/components/steps.dart';
import 'package:taskwire/components/tools.dart';
import 'package:taskwire/cubits/cubits.dart';

class JobWidget extends StatefulWidget {
  const JobWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  SSHBackend? backend;
  Machine? selected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MachinesCubit, Machines>(
      builder: (machinesContext, machinesState) {
        var defaultMachine = machinesState.machines.isNotEmpty ? machinesState.machines.last : null;

        return BlocBuilder<CurrentJobCubit, Job>(builder: (currentJobContext, currentJobState) {
          if (currentJobState.steps.isEmpty) {
            return const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Opacity(opacity: 0.5, child: Text('nothing selected')),
            );
          }

          List<Widget> timeline = [];
          for (var i = 0; i < currentJobState.steps.length; i++) {
            timeline.add(CommandStep(
                status: currentJobState.steps[i].status,
                fn: () {
                  if (backend != null) {
                    currentJobContext.read<CurrentJobCubit>().resetStep(i);
                    runStepCommand(currentJobContext, backend!, currentJobState.steps, i);
                  }
                },
                progress: currentJobState.steps[i].progress,
                command: currentJobState.steps[i].command,
                out: currentJobState.steps[i].out));
          }

          timeline.add(EndStep(status: currentJobState.steps[currentJobState.steps.length - 1].status));

          if (currentJobState.startNow) {
            runAll(backend, currentJobContext, currentJobState, defaultMachine)();
          }

          return Tools(
            tools: [
              ToolsItem(
                iconPath: regularArrowDoubleRight,
                color: friendly,
                label: 'Run all',
                onClick: runAll(backend, currentJobContext, currentJobState, defaultMachine),
              ),
              const Spacer(),
              Container(
                constraints: const BoxConstraints(maxHeight: 44),
                child: BlocBuilder<PasscodeCubit, Passcode>(
                  builder: (passcodeContext, passcodeState) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<Machine>(
                        enableFeedback: false,
                        alignment: Alignment.centerRight,
                        value: selected ?? defaultMachine,
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: SvgPicture.asset(
                            regularCloudImport,
                            height: 20,
                            color: authority,
                          ),
                        ),
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(inherit: false),
                        dropdownColor: bg,
                        focusColor: Colors.transparent,
                        onChanged: ((value) {
                          if (value != null) {
                            setState(() {
                              selected = value;
                              backend = SSHBackendSecure(
                                value.host,
                                value.port,
                                value.user,
                                value.rsa,
                                passcodeState.passcode!,
                              );
                            });
                          }
                        }),
                        items: machinesState.machines.map<DropdownMenuItem<Machine>>((Machine value) {
                          return DropdownMenuItem<Machine>(
                            alignment: Alignment.centerRight,
                            value: value,
                            child: Text(
                              value.name,
                              style: const TextStyle(color: authority),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              )
            ],
            child: ListView(
              controller: ScrollController(),
              shrinkWrap: true,
              children: timeline,
            ),
          );
        });
      },
    );
  }

  Null Function() runAll(
      SSHBackend? backend, BuildContext currentJobContext, Job currentJobState, Machine? defaultMachine) {
    return () {
      if (backend == null) {
        return;
      }

      if (selected == null) {
        if (defaultMachine == null) {
          setState(() {
            selected = defaultMachine;
          });
        }
      }

      currentJobContext.read<CurrentJobCubit>().resetRuns();
      currentJobContext.read<CurrentJobCubit>().mustRun(false);

      int stepIndex = 0;
      void Function()? recursiveRun;

      recursiveRun = () {
        if (stepIndex >= currentJobState.steps.length) {
          return;
        }
        runStepCommand(currentJobContext, backend, currentJobState.steps, stepIndex, recursiveRun);
        stepIndex++;
      };

      recursiveRun();
    };
  }

  void runStepCommand(BuildContext context, Backend backend, List<StepData> steps, int stepIndex,
      [void Function()? callback]) {
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
