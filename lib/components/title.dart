import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({
    Key? key,
    required this.title,
    this.back = false,
  }) : super(key: key);

  final String title;
  final bool back;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (back)
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                '<-- ',
                style: Theme.of(context).textTheme.bodyText1,
              )),
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
