import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskwire/colors.dart';

class Tools extends StatelessWidget {
  const Tools({
    Key? key,
    required this.tools,
    required this.child,
  }) : super(key: key);

  final List<ToolsItem> tools;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: tools,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class ToolsItem extends StatelessWidget {
  const ToolsItem({
    Key? key,
    required this.iconPath,
    required this.label,
    required this.onClick,
  }) : super(key: key);

  final String iconPath;
  final String label;
  final Null Function() onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: TextButton.icon(
        onPressed: onClick,
        style: TextButton.styleFrom(
            minimumSize: const Size(10, 30),
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
            alignment: Alignment.centerRight),
        icon: SvgPicture.asset(
          iconPath,
          height: 20,
        ),
        label: Text(
          label,
          style: Theme.of(context).textTheme.bodyText2?.copyWith(color: friendly),
        ),
      ),
    );
  }
}
