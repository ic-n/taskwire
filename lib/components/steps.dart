import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskwire/components/line.dart';

const iconOK = "assets/icons/green/streamlinehq-interface-validation-check-circle-interface-essential-48.SVG";
const iconContinue = "assets/icons/yellow/streamlinehq-interface-arrows-right-circle-interface-essential-48.SVG";
const iconGo = "assets/icons/yellow/streamlinehq-interface-arrows-right-circle-interface-essential-48.SVG";

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
    var outLines = out.trim().split("\n");

    bool x = out == "" || outLines.isEmpty;

    return Step(icon: status ? iconOK : iconContinue, iconClick: fn, progress: progress, lines: x ? 2 : 4, children: [
      Text(
        "Running command: $command",
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 40 * 3),
          child: out == "" || outLines.isEmpty
              ? Opacity(opacity: .4, child: Text(status ? "  * silence" : "  running..."))
              : ListView.builder(
                  itemCount: outLines.length,
                  itemBuilder: ((context, index) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Opacity(
                          opacity: .4 + ((index % 2) / 10),
                          child: Text(
                            '${index + 1} '.padLeft(4),
                          ),
                        ),
                        Expanded(
                            child: Opacity(
                          opacity: .3 + ((index % 2) / 10),
                          child: Text(
                            outLines[index],
                          ),
                        ))
                      ],
                    );
                  }),
                ),
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
    return Step(icon: status ? iconOK : iconContinue, iconClick: () {}, progress: 0, lines: 0, children: [
      Row(
        children: [
          Text(
            "Finished",
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          if (status)
            TextButton(
                style: TextButton.styleFrom(minimumSize: const Size(10, 30), padding: EdgeInsets.zero),
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
    double wid = MediaQuery.of(context).size.width;

    var body = Container(
      constraints: BoxConstraints(
        minHeight: 40,
        maxWidth: (wid / 3) - 65,
      ),
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
