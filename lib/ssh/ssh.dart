import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskwire/cubits/liveterm.dart';

class SSHTerm extends StatefulWidget {
  const SSHTerm({
    Key? key,
    required this.host,
    required this.port,
    required this.user,
    required this.password,
  }) : super(key: key);

  final String host;
  final int port;
  final String user;
  final String password;

  @override
  State<SSHTerm> createState() => _SSHTermState();
}

class _SSHTermState extends State<SSHTerm> {
  String cmd = '';
  List<OutputToken> tokens = [];
  void Function()? killer;

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveTerminalCubit, Term>(builder: (context, state) {
      context.read<LiveTerminalCubit>().connect(
            widget.host,
            widget.port,
            widget.user,
            widget.password,
          );

      List<Widget> lines = [];

      for (var executions in state.executions) {
        List<TextSpan> textLines = [];

        lines.add(Text(
          '-> ${executions.cmd} (${executions.exitCode})',
          style: Theme.of(context).textTheme.bodyText1,
        ));

        for (var token in executions.tokens.tokens) {
          textLines.add(TextSpan(
            text: token.content,
            style: TextStyle(color: token.color),
          ));
        }

        lines.add(RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: textLines,
          ),
        ));
      }

      if (killer != null) {
        lines.add(Text(
          '-> $cmd',
          style: Theme.of(context).textTheme.bodyText1,
        ));

        List<TextSpan> textLines = [];
        for (var token in tokens) {
          textLines.add(TextSpan(
            text: token.content,
            style: TextStyle(color: token.color),
          ));

          lines.add(RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: textLines,
            ),
          ));
        }

        lines.add(Row(
          children: [
            TextButton(
              onPressed: killer,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.hovered)) {
                    return Colors.white;
                  }
                  return Colors.white.withAlpha(50);
                }),
              ),
              child: Text(
                'stop it',
                style: Theme.of(context).textTheme.bodyText2?.merge(const TextStyle(color: Colors.black)),
              ),
            )
          ],
        ));
      }

      lines.add(Container(
        constraints: const BoxConstraints(minWidth: 50),
        child: TextFormField(
          onFieldSubmitted: (value) {
            context.read<LiveTerminalCubit>().sendCommand(cmd, () {
              setState(() {
                killer = null;
                tokens = [];
              });
              Future.delayed(const Duration(milliseconds: 250), () {
                _controller.animateTo(_controller.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
              });
            }, (toks) {
              setState(() {
                tokens = toks;
                _controller.animateTo(_controller.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
              });
            }, (k) {
              setState(() {
                killer = k;
              });
            });
          },
          onChanged: (value) {
            setState(() {
              cmd = value;
            });
          },
          style: Theme.of(context).textTheme.bodyText1?.copyWith(color: Colors.white),
          enabled: (killer == null),
          decoration: InputDecoration(
              isDense: true,
              prefixIcon: Text(
                '\$ ',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
              border: InputBorder.none,
              enabledBorder: InputBorder.none),
        ),
      ));
      return Expanded(
        child: ListView(
          controller: _controller,
          children: lines,
        ),
      );
    });
  }
}
