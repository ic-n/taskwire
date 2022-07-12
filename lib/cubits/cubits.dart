import 'package:flutter_bloc/flutter_bloc.dart';

class JobCard {
  final String title;
  final List<StepData> steps;
  final int? jobIndex;

  JobCard(this.title, this.steps, [this.jobIndex]);
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
  JobCardsCubit() : super(JobCards([], JobCard("", [])));

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
    this.out = "",
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
