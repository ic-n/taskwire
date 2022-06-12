import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskwire/components/line.dart';

const iconOK =
    "assets/icons/green/streamlinehq-interface-validation-check-circle-interface-essential-48.SVG";
const iconContinue =
    "assets/icons/yellow/streamlinehq-interface-arrows-right-circle-interface-essential-48.SVG";
const iconGo =
    "assets/icons/yellow/streamlinehq-interface-arrows-right-circle-interface-essential-48.SVG";

class CommandStep extends StatelessWidget {
  const CommandStep({
    Key? key,
    required this.status,
    required this.fn,
    required this.progress,
    required this.command,
    required this.out,
  }) : super(key: key);

  final bool status;
  final Null Function() fn;
  final double progress;
  final String command;
  final String out;

  @override
  Widget build(BuildContext context) {
    return Step(
        icon: status ? iconOK : iconContinue,
        iconClick: fn,
        progress: progress,
        lines: 2,
        children: [
          Text(
            "Running command: $command",
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "> $out",
              overflow: TextOverflow.ellipsis,
            ),
          )
        ]);
  }
}

class EndStep extends StatelessWidget {
  const EndStep({
    Key? key,
    required this.status,
  }) : super(key: key);

  final bool status;

  @override
  Widget build(BuildContext context) {
    return Step(
        icon: status ? iconOK : iconContinue,
        iconClick: () {},
        progress: 0,
        lines: 0,
        children: [
          Row(
            children: [
              Text(
                "Finished",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              if (status)
                TextButton(
                    style: TextButton.styleFrom(
                        minimumSize: const Size(10, 30),
                        padding: EdgeInsets.zero),
                    onPressed: () {},
                    child: Text(
                      ", go to server",
                      style: Theme.of(context).textTheme.bodyText2,
                    )),
            ],
          )
        ]);
  }
}

class Step extends StatelessWidget {
  const Step({
    Key? key,
    required this.icon,
    required this.iconClick,
    required this.progress,
    required this.children,
    this.lines = 1,
  }) : super(key: key);

  final String icon;
  final void Function() iconClick;
  final double progress;
  final List<Widget> children;
  final double lines;

  @override
  Widget build(BuildContext context) {
    var body = Container(
      constraints: const BoxConstraints(minHeight: 40),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );

    var button = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
            onPressed: (iconClick),
            style: TextButton.styleFrom(
                minimumSize: const Size(10, 30),
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerRight),
            child: SvgPicture.asset(
              icon,
              height: 40,
            )),
      ],
    );
    Widget side = button;
    if (lines != 0) {
      side = CustomPaint(
        painter: LoadingLine(progress: progress),
        child: SizedBox(
          height: (40 * lines) + (10 * (lines - 1)),
          child: button,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        side,
        // Tooltip(message:'$progress',child: side),
        body,
      ],
    );
  }
}
