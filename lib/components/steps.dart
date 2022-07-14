import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskwire/assets.dart';
import 'package:taskwire/colors.dart';
import 'package:taskwire/components/line.dart';

var startIc = regularSquareRight;
var runningIc = regularSquareDown;
var doneIc = regularSquareTick;

const cSize = 30.0;

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
    var outLines = out.trim().split('\n');

    bool outIsZero = (out == '' || outLines.isEmpty);
    bool isActive = (!(!status && progress == 0)) && (!(outIsZero && status));

    return Step(
        icon: status ? doneIc : (isActive ? runningIc : startIc),
        color: status ? refreshing : (isActive ? authority : friendly),
        iconClick: fn,
        progress: progress,
        lines: outIsZero ? (isActive ? 2 : 0) : 4,
        children: [
          Text(
            command,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          if (isActive)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                constraints: const BoxConstraints(maxHeight: cSize * 3),
                child: outIsZero
                    ? Opacity(opacity: .4, child: Text(status ? '  * silence' : '  running...'))
                    : ListView.builder(
                        itemCount: outLines.length,
                        controller: ScrollController(),
                        itemBuilder: ((context, index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Opacity(
                                opacity: .4 + ((index % 2) / 10),
                                child: Text(
                                  '${index + 1} '.padLeft(3),
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
    return Step(
        icon: status ? doneIc : startIc,
        color: status ? refreshing : friendly,
        iconClick: () {},
        progress: 0,
        lines: 0,
        children: [
          Text(
            'Finished',
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1,
          ),
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
    required this.color,
    this.lines = 1,
  }) : super(key: key);

  final String icon;
  final void Function() iconClick;
  final double progress;
  final List<Widget> children;
  final Color color;
  final double lines;

  @override
  Widget build(BuildContext context) {
    var body = Flexible(
      child: Container(
        constraints: BoxConstraints(maxHeight: cSize * (lines + 1) + 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
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
                backgroundColor: Colors.black,
                padding: EdgeInsets.zero,
                alignment: Alignment.centerRight),
            child: SvgPicture.asset(
              icon,
              color: color,
              height: cSize,
            )),
      ],
    );
    Widget side = button;
    if (lines != 0) {
      side = CustomPaint(
        painter: LoadingLine(progress: progress),
        child: SizedBox(
          height: cSize * (lines + 1),
          child: button,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        side,
        body,
      ],
    );
  }
}
