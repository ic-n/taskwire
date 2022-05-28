import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskwire/components/title.dart';

class PageJobs extends StatelessWidget {
  const PageJobs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageTitle(title: "Jobs"),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2,
                    children: [
                      Tile(title: "Title", body: "Text", onClick: () {}),
                    ]),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageTitle(title: "Job"),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/green/streamlinehq-computer-battery-level-medium-computer-devices-48.SVG",
                          width: 40,
                        ),
                        SizedBox(width: 5,),
                        Text("Text my text"),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.title,
    required this.onClick,
    required this.body,
  }) : super(key: key);

  final String title;
  final Null Function() onClick;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18),
                  ),
                  TextButton(
                      onPressed: (onClick),
                      child: SvgPicture.asset(
                        "assets/icons/yellow/streamlinehq-interface-arrows-right-circle-interface-essential-48.SVG",
                        height: 40,
                      ))
                ],
              ),
              Text(
                body,
                style: const TextStyle(fontSize: 12),
              )
            ]),
      ),
    );
  }
}
