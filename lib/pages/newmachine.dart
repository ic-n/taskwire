import 'package:flutter/material.dart';
import 'package:taskwire/backend/backend.dart';
import 'package:taskwire/colors.dart';
import 'package:taskwire/components/title.dart';
import 'package:taskwire/components/twforms.dart';
import 'package:taskwire/cubits/cubits.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageNewMachine extends StatelessWidget {
  const PageNewMachine({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Flexible(
        flex: 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            PageTitle(
              title: 'New SSH machine',
              back: true,
            ),
            SizedBox(
              height: 12,
            ),
            NewMachineForm(),
          ],
        ),
      ),
    ]);
  }
}

class NewMachineForm extends StatefulWidget {
  const NewMachineForm({
    Key? key,
  }) : super(key: key);

  @override
  State<NewMachineForm> createState() => _NewMachineFormState();
}

class _NewMachineFormState extends State<NewMachineForm> {
  String name = '';
  String host = '';
  int port = 22;
  String user = '';
  String password = '';
  String rsa = '';
  bool rsaIsLoading = false;
  bool rsaIsSet = false;
  String rsaError = '';

  @override
  Widget build(BuildContext context) {
    var spacer = const SizedBox(
      width: 25,
      height: 25,
    );
    var smallSpacer = const SizedBox(
      height: 10,
    );
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TWField(
              title: 'New machine name',
              hint: 'My home server',
              initialValue: name,
              color: intelegence,
              callback: (s) {
                setState(() {
                  name = s;
                  rsaIsLoading = false;
                  rsaIsSet = false;
                  rsaError = '';
                });
              },
            ),
            smallSpacer,
            TWField(
              title: 'Machine host',
              hint: 'ssh.example.com',
              initialValue: host,
              color: intelegence,
              callback: (s) {
                setState(() {
                  host = s;
                  rsaIsLoading = false;
                  rsaIsSet = false;
                  rsaError = '';
                });
              },
            ),
            smallSpacer,
            TWNumberField(
              title: 'Machine port',
              hint: '22',
              initialValue: port.toString(),
              color: intelegence,
              callback: (s) {
                setState(() {
                  port = int.parse(s);
                  rsaIsLoading = false;
                  rsaIsSet = false;
                  rsaError = '';
                });
              },
            ),
            TWField(
              title: 'Machine user',
              hint: 'root',
              initialValue: user,
              color: intelegence,
              callback: (s) {
                setState(() {
                  user = s;
                  rsaIsLoading = false;
                  rsaIsSet = false;
                  rsaError = '';
                });
              },
            ),
            TWPasswordField(
              title: 'Machine password',
              hint: 'password for $user',
              initialValue: password,
              color: intelegence,
              callback: (s) {
                setState(() {
                  password = s;
                  rsaIsLoading = false;
                  rsaIsSet = false;
                  rsaError = '';
                });
              },
            ),
            spacer,
            rsaIsSet
                ? TWButton(
                    lable: 'Save',
                    color: intelegence,
                    callback: () {
                      context.read<MachinesCubit>().addMachine(
                            Machine(name, host, port, user, rsa),
                          );
                      Navigator.pop(context);
                    },
                  )
                : (rsaIsLoading
                    ? const TWButtonLoading(
                        color: bgd,
                      )
                    : BlocBuilder<PasscodeCubit, Passcode>(
                        builder: (context, state) {
                          return TWButton(
                            lable: 'Exchange keys',
                            color: intelegence,
                            callback: () async {
                              if (state.passcode == null) {
                                return;
                              }

                              setState(() {
                                rsaIsLoading = true;
                                rsaError = '';
                              });

                              var backend = SSHBackendPwd(
                                host,
                                port,
                                user,
                                password,
                              );
                              final String privKey;
                              try {
                                privKey = await backend.keyExchange(state.passcode!);
                              } catch (e) {
                                setState(() {
                                  rsaIsSet = false;
                                  rsaIsLoading = false;
                                  rsaError = 'connection issue ${e.toString()}';
                                });
                                return;
                              }
                              setState(() {
                                rsa = privKey;
                                rsaIsSet = true;
                                rsaError = '';
                              });
                            },
                          );
                        },
                      )),
            if (rsaError != '')
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(rsaError),
              ),
          ],
        ),
      ),
    );
  }
}
