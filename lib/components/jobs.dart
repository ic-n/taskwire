import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskwire/cubits/cubits.dart';

class JobsWidget extends StatelessWidget {
  const JobsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocProvider(
        create: (context) => JobCardsCubit(),
        child: BlocBuilder<JobCardsCubit, List<JobCard>>(
            builder: (context, state) {
          var tiles = [
            Tile(
                title: "New task",
                body: "",
                path:
                    "assets/icons/yellow/streamlinehq-interface-add-circle-interface-essential-48.SVG",
                onClick: () {
                  context.read<JobCardsCubit>().addNew();
                }),
          ];
          for (var jobCard in state) {
            tiles.add(Tile(
                title: jobCard.title,
                body: jobCard.body,
                path:
                    "assets/icons/yellow/streamlinehq-interface-arrows-right-circle-interface-essential-48.SVG",
                onClick: () {}));
          }
          return GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2,
              children: tiles);
        }),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.title,
    required this.path,
    required this.onClick,
    required this.body,
  }) : super(key: key);

  final String title;
  final String path;
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
                      style: TextButton.styleFrom(
                          minimumSize: const Size(10, 30),
                          shape: const CircleBorder(),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerRight),
                      child: SvgPicture.asset(
                        path,
                        height: 40,
                      ))
                ],
              ),
              Opacity(
                opacity: 0.5,
                child: Text(
                  body,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              )
            ]),
      ),
    );
  }
}
