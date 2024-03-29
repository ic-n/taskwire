import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskwire/assets.dart';
import 'package:taskwire/colors.dart';

class TWButton extends StatelessWidget {
  const TWButton({
    Key? key,
    required this.lable,
    required this.callback,
    required this.color,
  }) : super(key: key);

  final String lable;
  final void Function() callback;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide.none,
        )),
        backgroundColor: MaterialStateProperty.all(color),
      ),
      onPressed: callback,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Text(lable, style: Theme.of(context).textTheme.bodyText2),
      ),
    );
  }
}

class TWButtonLoading extends StatefulWidget {
  const TWButtonLoading({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  State<TWButtonLoading> createState() => _TWButtonLoadingState();
}

class _TWButtonLoadingState extends State<TWButtonLoading> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..repeat();

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(150),
          side: BorderSide.none,
        )),
        backgroundColor: MaterialStateProperty.all(widget.color),
      ),
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * pi,
              child: child,
            );
          },
          child: SvgPicture.asset(
            regularRefresh,
            color: fgl,
          ),
        ),
      ),
    );
  }
}

class TWMetaField extends StatefulWidget {
  const TWMetaField({
    Key? key,
    required this.title,
    required this.hint,
    required this.initialValue,
    required this.callback,
    required this.color,
    required this.obscureText,
    required this.inputFormatters,
    this.textInputType,
    this.lines = 1,
  }) : super(key: key);

  final String title;
  final String hint;
  final String initialValue;
  final void Function(String) callback;
  final Color color;
  final TextInputType? textInputType;
  final bool obscureText;
  final List<TextInputFormatter> inputFormatters;
  final int lines;

  @override
  State<TWMetaField> createState() => _TWMetaFieldState();
}

class _TWMetaFieldState extends State<TWMetaField> {
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
          obscureText: widget.obscureText,
          controller: textEditingController,
          keyboardType: widget.textInputType,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            enabledBorder: inputBorder(0, widget.color),
            focusedBorder: inputBorder(2, widget.color),
            border: inputBorder(0, widget.color),
            contentPadding: const EdgeInsets.all(20),
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

class TWField extends StatelessWidget {
  const TWField({
    Key? key,
    required this.title,
    required this.hint,
    required this.initialValue,
    required this.callback,
    required this.color,
    this.lines = 1,
  }) : super(key: key);

  final String title;
  final String hint;
  final String initialValue;
  final void Function(String) callback;
  final Color color;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return TWMetaField(
      title: title,
      hint: hint,
      initialValue: initialValue,
      callback: callback,
      color: color,
      obscureText: false,
      inputFormatters: const [],
      lines: lines,
    );
  }
}

class TWPasswordField extends StatelessWidget {
  const TWPasswordField({
    Key? key,
    required this.title,
    required this.hint,
    required this.initialValue,
    required this.callback,
    required this.color,
    this.lines = 1,
  }) : super(key: key);

  final String title;
  final String hint;
  final String initialValue;
  final void Function(String) callback;
  final Color color;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return TWMetaField(
      title: title,
      hint: hint,
      initialValue: initialValue,
      callback: callback,
      color: color,
      obscureText: true,
      inputFormatters: const [],
      lines: lines,
    );
  }
}

class TWNumberField extends StatelessWidget {
  const TWNumberField({
    Key? key,
    required this.title,
    required this.hint,
    required this.initialValue,
    required this.callback,
    required this.color,
    this.lines = 1,
  }) : super(key: key);

  final String title;
  final String hint;
  final String initialValue;
  final void Function(String) callback;
  final Color color;
  final int lines;

  @override
  Widget build(BuildContext context) {
    return TWMetaField(
      title: title,
      hint: hint,
      initialValue: initialValue,
      callback: callback,
      color: color,
      textInputType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      obscureText: false,
      lines: lines,
    );
  }
}

OutlineInputBorder inputBorder(double width, Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: width > 0
        ? BorderSide(
            color: color.withAlpha(100),
            width: width,
            style: BorderStyle.solid,
          )
        : BorderSide.none,
  );
}

class TWBox extends StatelessWidget {
  const TWBox({
    Key? key,
    required this.body,
  }) : super(key: key);

  final List<Widget> body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: bgd,
        ),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: body,
          ),
        ),
      ),
    );
  }
}

class TWPara extends StatelessWidget {
  const TWPara({
    Key? key,
    required this.paragraph,
  }) : super(key: key);

  final String paragraph;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(paragraph),
    );
  }
}
