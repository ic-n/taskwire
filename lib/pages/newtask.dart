import 'package:flutter/material.dart';
import 'package:taskwire/colors.dart';
import 'package:taskwire/components/task.dart';
import 'package:taskwire/components/title.dart';
import 'package:taskwire/components/twforms.dart';
import 'package:taskwire/cubits/cubits.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageNewTask extends StatelessWidget {
  const PageNewTask({
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
          children: [
            const PageTitle(
              title: 'New task',
              back: true,
            ),
            const SizedBox(
              height: 12,
            ),
            BlocBuilder<TaskCardsCubit, TaskCards>(
              builder: (context, state) {
                String body = '';
                for (var element in state.currentEdit.steps) {
                  body += '${element.command}\n';
                }
                return NewTaskForm(
                  state.currentEdit.title,
                  body,
                  taskIndex: state.currentEdit.taskIndex,
                );
              },
            ),
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
            PageTitle(title: 'Task'),
            TaskWidget(),
          ],
        ),
      )
    ]);
  }
}

class NewTaskForm extends StatefulWidget {
  const NewTaskForm(
    this.title,
    this.body, {
    Key? key,
    this.taskIndex,
  }) : super(key: key);

  final String title;
  final String body;
  final int? taskIndex;

  @override
  State<NewTaskForm> createState() => _NewTaskFormState();
}

class _NewTaskFormState extends State<NewTaskForm> {
  String title = '';
  String body = '';
  int? taskIndex;

  @override
  void initState() {
    title = widget.title;
    body = widget.body;
    taskIndex = widget.taskIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var spacer = const SizedBox(
      height: 25,
    );
    var smallSpacer = const SizedBox(
      height: 10,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TWField(
          title: 'New task title',
          hint: 'My new task',
          initialValue: title,
          color: confidence,
          callback: (s) {
            setState(() {
              title = s;
            });
          },
        ),
        smallSpacer,
        TWField(
          title: 'New task comands',
          hint: 'echo hello\napk add python3\npip install pillow\n',
          initialValue: body,
          color: confidence,
          callback: (s) {
            setState(() {
              body = s;
            });
            context.read<CurrentTaskCubit>().steps(asSteps());
          },
          lines: 9,
        ),
        spacer,
        TWButton(
            lable: 'Save',
            color: confidence,
            callback: () {
              if (taskIndex == null) {
                context.read<TaskCardsCubit>().addNew(TaskCard(title, asSteps(), DateTime.now()));
              } else {
                context.read<TaskCardsCubit>().updateCard(TaskCard(title, asSteps(), DateTime.now()), taskIndex!);
              }
              Navigator.pop(context);
            }),
      ],
    );
  }

  List<StepData> asSteps() {
    List<StepData> steps = [];
    body.trim().split('\n').forEach((cmd) {
      steps.add(StepData(command: cmd.trim()));
    });
    return steps;
  }
}
