import 'package:flutter_bloc/flutter_bloc.dart';

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

class JobCardsCubit extends Cubit<JobCards> {
  JobCardsCubit() : super(JobCards([], JobCard('', [], DateTime.now())));

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
}

class Machine {
  final String name;
  final String host;
  final int port;
  final String user;
  final String password;

  Machine(this.name, this.host, this.port, this.user, this.password);
}

class Machines {
  List<Machine> machines = [];
  int selected = -1;

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => false;
}

class MachinesCubit extends Cubit<Machines> {
  MachinesCubit() : super(Machines());

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
