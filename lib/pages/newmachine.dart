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
  String name = 'Test';
  String host = 'localhost';
  int port = 2222;
  String user = 'root';
  String password = 'taskwire';
  String rsa = '';

  @override
  Widget build(BuildContext context) {
    var spacer = const SizedBox(
      width: 25,
      height: 25,
    );
    var smallSpacer = const SizedBox(
      height: 10,
    );
    return Column(
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
            });
          },
        ),
        spacer,
        Row(
          children: [
            TWButton(
              lable: 'Save',
              color: intelegence,
              callback: () {
                context.read<MachinesCubit>().addMachine(
                      Machine(name, host, port, user, password, rsa),
                    );
                Navigator.pop(context);
              },
            ),
            spacer,
            BlocBuilder<PasscodeCubit, Passcode>(
              builder: (context, state) {
                return TWButton(
                  lable: 'RSA key exchange ${state.passcode}, ${state.passcodeHash}',
                  color: intelegence,
                  callback: () async {
                    if (state.passcode == null) {
                      return;
                    }
                    var backend = SSHBackend(
                      host,
                      port,
                      user,
                      password,
                    );
                    final privKey = await backend.keyExchange(state.passcode!);
                    setState(() {
                      rsa = privKey;
                    });
                    // Navigator.pop(context);
                  },
                );
              },
            ),
          ],
        ),
        spacer,
        Container(
          constraints: const BoxConstraints(
            maxHeight: 120,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(rsa),
            ),
          ),
        ),
      ],
    );
  }
}
