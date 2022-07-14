import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:taskwire/assets.dart';
import 'package:taskwire/colors.dart';
import 'package:taskwire/components/jobs.dart';
import 'package:taskwire/components/title.dart';
import 'package:taskwire/components/tools.dart';
import 'package:taskwire/cubits/cubits.dart';
import 'package:taskwire/main.dart';
import 'package:taskwire/pages/newmachine.dart';
import 'package:taskwire/ssh/ssh.dart';

class PageServers extends StatelessWidget {
  const PageServers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        PageTitle(title: 'Servers'),
        SizedBox(
          height: 12,
        ),
        Expanded(child: ServersBody())
      ],
    );
  }
}

class ServersBody extends StatelessWidget {
  const ServersBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MachinesCubit, Machines>(builder: (context, state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Tools(
            tools: [
              ToolsItem(
                  iconPath: regularCloudPlus,
                  label: "Add new server",
                  color: authority,
                  onClick: () {
                    Navigator.push(
                        context,
                        PageTransition<Screen>(
                            type: PageTransitionType.fade, child: const Screen(screen: PageNewMachine())));
                  })
            ],
            child: ListView.builder(
              itemCount: state.machines.length,
              itemBuilder: ((context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: index % 2 == 0 ? bg.withAlpha(150) : bg.withAlpha(100),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(state.machines[index].name),
                      ),
                      Expanded(
                          child: Text(
                        '${state.machines[index].host}:${state.machines[index].port}',
                      )),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TileButton(
                              color: authority,
                              action: () {
                                context.read<MachinesCubit>().removeMachine(index);
                              },
                              buttonIcon: regularTrash,
                            ),
                            TileButton(
                              color: authority,
                              action: () {
                                context.read<MachinesCubit>().openTerm(index);
                              },
                              buttonIcon: regularWindowTerninal,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          if (state.selected != -1)
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1, color: bgl),
                  ),
                ),
                child: Stack(children: [
                  SSHTerm(
                    host: state.machines[state.selected].host,
                    port: state.machines[state.selected].port,
                    user: state.machines[state.selected].user,
                    password: state.machines[state.selected].password,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: TileButton(
                        action: () {
                          context.read<MachinesCubit>().closeTerm();
                        },
                        buttonIcon: regularSquareCross1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
              ),
            )
        ],
      );
    });
  }
}
