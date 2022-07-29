import 'package:hydrated_bloc/hydrated_bloc.dart';

class JobCard {
  final String title;
  final List<StepData> steps;
  final DateTime touched;
  final int? jobIndex;

  JobCard(this.title, this.steps, this.touched, [this.jobIndex]);
}

class JobCards {
  JobCards(this.cards, this.currentEdit);

  List<JobCard> cards;
  JobCard currentEdit;

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => false;
}

class JobCardsCubit extends HydratedCubit<JobCards> {
  JobCardsCubit() : super(JobCards([], JobCard('', [], DateTime.now())));

  @override
  Map<String, dynamic>? toJson(JobCards state) {
    List<Map<String, dynamic>> cards = [];
    for (var card in state.cards) {
      List<Map<String, dynamic>> steps = [];
      for (var step in card.steps) {
        steps.add({'command': step.command});
      }
      cards.add({
        'title': card.title,
        'touched': card.touched.toIso8601String(),
        'steps': steps,
      });
    }
    return {'cards': cards};
  }

  @override
  JobCards? fromJson(Map<String, dynamic> json) {
    List<JobCard> cards = [];
    for (var cardData in json['cards'] as List<dynamic>) {
      var card = cardData as Map<String, dynamic>;
      List<StepData> steps = [];
      for (var stepData in card['steps'] as List<dynamic>) {
        var step = stepData as Map<String, dynamic>;
        steps.add(StepData(command: step['command'] as String));
      }
      cards.add(JobCard(
        card['title'] as String,
        steps,
        DateTime.parse(card['touched'] as String),
      ));
    }
    return JobCards(cards, JobCard('', [], DateTime.now()));
  }

  void addNew(JobCard newCard) {
    state.cards.add(newCard);
    emit(state);
  }

  void updateCard(JobCard newCard, int index) {
    state.cards[index] = newCard;
    emit(state);
  }

  void setCurrentEdit(JobCard newCard) {
    state.currentEdit = newCard;
    emit(state);
  }
}

class StepData {
  StepData({
    required this.command,
    this.out = '',
    this.status = false,
    this.progress = 0,
  });

  double progress;
  bool status;
  String command;
  String out;
}

class Job {
  bool startNow = false;
  List<StepData> steps = [];

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => false;
}

class CurrentJobCubit extends Cubit<Job> {
  CurrentJobCubit() : super(Job());

  void resetRuns() {
    List<StepData> newSteps = [];
    for (var i = 0; i < state.steps.length; i++) {
      var newStep = state.steps[i];
      newStep.out = '';
      newStep.status = false;
      newStep.progress = 0;
      newSteps.add(newStep);
    }
    state.steps = newSteps;
    emit(state);
  }

  void resetStep(int at) {
    List<StepData> newSteps = [];
    for (var i = 0; i < state.steps.length; i++) {
      if (i == at) {
        var newStep = state.steps[i];
        newStep.out = '';
        newStep.status = false;
        newStep.progress = 0;
        newSteps.add(newStep);
        continue;
      }
      newSteps.add(state.steps[i]);
    }
    state.steps = newSteps;
    emit(state);
  }

  void updateStep(int at, StepData newStep) {
    List<StepData> newSteps = [];
    for (var i = 0; i < state.steps.length; i++) {
      if (i == at) {
        newSteps.add(newStep);
        continue;
      }
      newSteps.add(state.steps[i]);
    }
    state.steps = newSteps;
    emit(state);
  }

  void steps(List<StepData> newSteps) {
    state.steps = newSteps;
    emit(state);
  }

  void mustRun([bool? must]) {
    state.startNow = must ?? true;
    emit(state);
  }
}

class Machine {
  final String name;
  final String host;
  final int port;
  final String user;
  final String password;
  final String rsa;

  Machine(this.name, this.host, this.port, this.user, this.password, this.rsa);
}

class Machines {
  List<Machine> machines = [];
  int selected = -1;

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => false;
}

class MachinesCubit extends HydratedCubit<Machines> {
  MachinesCubit() : super(Machines());

  @override
  Map<String, dynamic>? toJson(Machines state) {
    List<Map<String, dynamic>> machines = [];
    for (var machine in state.machines) {
      machines.add({
        'name': machine.name,
        'host': machine.host,
        'port': machine.port,
        'user': machine.user,
        'password': machine.password,
        'rsa': machine.rsa,
      });
    }
    return {
      'machines': machines,
    };
  }

  @override
  Machines? fromJson(Map<String, dynamic> json) {
    var machines = Machines();
    for (var machineData in json['machines'] as List<dynamic>) {
      var machine = machineData as Map<String, dynamic>;
      machines.machines.add(Machine(
        machine['name'] as String,
        machine['host'] as String,
        machine['port'] as int,
        machine['user'] as String,
        machine['password'] as String,
        (machine['rsa'] ?? '') as String,
      ));
    }
    return machines;
  }

  void openTerm(int id) {
    state.selected = id;
    emit(state);
  }

  void closeTerm() {
    state.selected = -1;
    emit(state);
  }

  void addMachine(Machine newMach) {
    state.machines.add(newMach);
    emit(state);
  }

  void removeMachine(int at) {
    List<Machine> newMachines = [];
    for (var i = 0; i < state.machines.length; i++) {
      if (i == at) {
        continue;
      }
      newMachines.add(state.machines[i]);
    }
    state.machines = newMachines;
    emit(state);
  }

  void updateMachine(int at, Machine newMachine) {
    List<Machine> newMachines = [];
    for (var i = 0; i < state.machines.length; i++) {
      if (i == at) {
        newMachines.add(newMachine);
        continue;
      }
      newMachines.add(state.machines[i]);
    }
    state.machines = newMachines;
    emit(state);
  }
}
