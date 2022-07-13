import 'package:flutter/material.dart';
import 'package:taskwire/backend/backend.dart';
import 'package:taskwire/colors.dart';
import 'package:taskwire/components/job.dart';
import 'package:taskwire/components/title.dart';
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
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
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
              BlocBuilder<JobCardsCubit, JobCards>(
                builder: (context, state) {
                  String body = '';
                  for (var element in state.currentEdit.steps) {
                    body += '${element.command}\n';
                  }
                  return NewTaskForm(
                    state.currentEdit.title,
                    body,
                    jobIndex: state.currentEdit.jobIndex,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      Flexible(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageTitle(title: 'Job'),
              const SizedBox(
                height: 12,
              ),
              JobWidget(
                backend: SSHBackend(
                  'localhost',
                  2222,
                  'root',
                  'taskwire',
                ),
              ),
            ],
          ),
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
    this.jobIndex,
  }) : super(key: key);

  final String title;
  final String body;
  final int? jobIndex;

  @override
  State<NewTaskForm> createState() => _NewTaskFormState();
}

class _NewTaskFormState extends State<NewTaskForm> {
  String title = '';
  String body = '';
  int? jobIndex;

  @override
  void initState() {
    title = widget.title;
    body = widget.body;
    jobIndex = widget.jobIndex;
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
          callback: (s) {
            setState(() {
              body = s;
            });
            context.read<CurrentJobCubit>().steps(asSteps());
          },
          lines: 9,
        ),
        spacer,
        TWButton(
            lable: 'Save',
            callback: () {
              if (jobIndex == null) {
                context.read<JobCardsCubit>().addNew(JobCard(title, asSteps()));
              } else {
                context.read<JobCardsCubit>().updateCard(JobCard(title, asSteps()), jobIndex!);
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

class TWButton extends StatelessWidget {
  const TWButton({
    Key? key,
    required this.lable,
    required this.callback,
  }) : super(key: key);

  final String lable;
  final void Function() callback;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide.none,
        )),
        backgroundColor: MaterialStateProperty.all(confidence),
      ),
      onPressed: callback,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Text(lable, style: Theme.of(context).textTheme.bodyText2),
      ),
    );
  }
}

class TWField extends StatefulWidget {
  const TWField({
    Key? key,
    required this.title,
    required this.hint,
    required this.initialValue,
    required this.callback,
    this.lines = 1,
  }) : super(key: key);

  final String title;
  final String hint;
  final String initialValue;
  final int lines;
  final void Function(String) callback;

  @override
  State<TWField> createState() => _TWFieldState();
}

class _TWFieldState extends State<TWField> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.text = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ),
        TextField(
          onChanged: widget.callback,
          style: Theme.of(context).textTheme.bodyText2,
          maxLines: widget.lines,
          controller: textEditingController,
          decoration: InputDecoration(
            enabledBorder: inputBorder(0),
            focusedBorder: inputBorder(2),
            border: inputBorder(0),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            fillColor: bg,
            filled: true,
            hintText: widget.hint,
            hintStyle: Theme.of(context).textTheme.bodyText2?.copyWith(color: fgl.withAlpha(90)),
          ),
        ),
      ],
    );
  }
}

OutlineInputBorder inputBorder(double w) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: w > 0
        ? BorderSide(
            color: friendly.withAlpha(100),
            width: w,
            style: BorderStyle.solid,
          )
        : BorderSide.none,
  );
}
