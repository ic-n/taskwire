import 'package:flutter/material.dart';
import 'package:taskwire/colors.dart';
import 'package:taskwire/components/title.dart';
import 'package:taskwire/cubits/cubits.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageNewTask extends StatelessWidget {
  const PageNewTask({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: const [
            PageTitle(
              title: "New task",
              back: true,
            ),
            NewTaskForm(),
          ],
        ));
  }
}

class NewTaskForm extends StatefulWidget {
  const NewTaskForm({
    Key? key,
  }) : super(key: key);

  @override
  State<NewTaskForm> createState() => _NewTaskFormState();
}

class _NewTaskFormState extends State<NewTaskForm> {
  String title = "";
  String body = "";

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
        spacer,
        TWField(
          title: "New task title",
          hint: "My new task",
          callback: (s) {
            setState(() {
              title = s;
            });
          },
        ),
        smallSpacer,
        TWField(
          title: "New task comands",
          hint: "echo hello;\napk add python3;\npip install pillow;\n",
          callback: (s) {
            setState(() {
              body = s;
            });
          },
          lines: 9,
        ),
        spacer,
        TWButton(
            lable: "Save",
            callback: () {
              List<StepData> steps = [];
              body.trim().split("\n").forEach((cmd) {
                steps.add(StepData(command: cmd.trim()));
              });
              context.read<JobCardsCubit>().addNew(JobCard(title, steps));
              Navigator.pop(context);
            }),
      ],
    );
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

class TWField extends StatelessWidget {
  const TWField({
    Key? key,
    required this.title,
    required this.hint,
    required this.callback,
    this.lines = 1,
  }) : super(key: key);

  final String title;
  final String hint;
  final int lines;
  final void Function(String) callback;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
        ),
        TextField(
          onChanged: callback,
          style: Theme.of(context).textTheme.bodyText2,
          maxLines: lines,
          decoration: InputDecoration(
            enabledBorder: inputBorder(0),
            focusedBorder: inputBorder(2),
            border: inputBorder(0),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            fillColor: bg,
            filled: true,
            hintText: hint,
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
