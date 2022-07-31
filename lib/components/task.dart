import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskwire/assets.dart';
import 'package:taskwire/backend/backend.dart';
import 'package:taskwire/colors.dart';
import 'package:taskwire/components/steps.dart';
import 'package:taskwire/components/tools.dart';
import 'package:taskwire/cubits/cubits.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  SSHBackend? backend;
  Machine? selected;
  String connectionError = "";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasscodeCubit, Passcode>(builder: (passcodeContext, passcodeState) {
      return BlocBuilder<MachinesCubit, Machines>(
        builder: (machinesContext, machinesState) {
          var defaultMachine = machinesState.machines.isNotEmpty ? machinesState.machines.last : null;

          return BlocBuilder<CurrentTaskCubit, Task>(builder: (currentTaskContext, currentTaskState) {
            final Widget timelineView;
            List<Widget> timeline = [];

            if (currentTaskState.steps.isNotEmpty) {
              if (connectionError != '') {
                timeline.add(Text('$connectionError\n'));
              }

              for (var i = 0; i < currentTaskState.steps.length; i++) {
                timeline.add(CommandStep(
                    status: currentTaskState.steps[i].status,
                    fn: () {
                      if (backend != null) {
                        currentTaskContext.read<CurrentTaskCubit>().resetStep(i);
                        runStepCommand(currentTaskContext, backend!, currentTaskState.steps, i);
                      }
                    },
                    progress: currentTaskState.steps[i].progress,
                    command: currentTaskState.steps[i].command,
                    out: currentTaskState.steps[i].out));
              }

              timeline.add(EndStep(status: currentTaskState.steps[currentTaskState.steps.length - 1].status));

              if (currentTaskState.startNow) {
                runAll(backend, currentTaskContext, currentTaskState, defaultMachine, passcodeState.passcode!)();
              }

              timelineView = ListView(
                controller: ScrollController(),
                shrinkWrap: true,
                children: timeline,
              );
            } else {
              timelineView = const Text("No task selected");
            }

            return Tools(
              tools: [
                ToolsItem(
                  iconPath: regularArrowDoubleRight,
                  color: friendly,
                  label: 'Run all',
                  onClick:
                      runAll(backend, currentTaskContext, currentTaskState, defaultMachine, passcodeState.passcode!),
                ),
                const Spacer(),
                Container(
                  constraints: const BoxConstraints(maxHeight: 44),
                  child: DropdownButtonHideUnderline(
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
                  ),
                ),
              ],
              child: timelineView,
            );
          });
        },
      );
    });
  }

  Null Function() runAll(SSHBackend? backend, BuildContext currentTaskContext, Task currentTaskState,
      Machine? defaultMachine, String passcode) {
    return () {
      if (selected == null) {
        backend ??= SSHBackendSecure(
          defaultMachine!.host,
          defaultMachine.port,
          defaultMachine.user,
          defaultMachine.rsa,
          passcode,
        );
      }

      backend ??= SSHBackendSecure(
        selected!.host,
        selected!.port,
        selected!.user,
        selected!.rsa,
        passcode,
      );

      currentTaskContext.read<CurrentTaskCubit>().resetRuns();
      currentTaskContext.read<CurrentTaskCubit>().mustRun(false);

      int stepIndex = 0;
      void Function()? recursiveRun;

      recursiveRun = () {
        if (stepIndex >= currentTaskState.steps.length) {
          return;
        }
        runStepCommand(currentTaskContext, backend!, currentTaskState.steps, stepIndex, recursiveRun);
        stepIndex++;
      };

      recursiveRun();
    };
  }

  void runStepCommand(BuildContext context, Backend backend, List<StepData> steps, int stepIndex,
      [void Function()? callback]) {
    try {
      backend.sendCommand(steps[stepIndex].command, (prog) {
        var newStep = steps[stepIndex];
        newStep.progress = prog;
        context.read<CurrentTaskCubit>().updateStep(stepIndex, newStep);
      }).then((value) {
        var newStep = steps[stepIndex];
        newStep.out = value;
        newStep.status = true;
        newStep.progress = 1;
        context.read<CurrentTaskCubit>().updateStep(stepIndex, newStep);
        if (callback != null) {
          callback();
        }
      });
    } catch (e) {
      setState(() {
        connectionError = 'connection issue ${e.toString()}';
      });
    }
  }
}
