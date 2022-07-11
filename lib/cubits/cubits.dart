import 'package:flutter_bloc/flutter_bloc.dart';

class JobCard {
  final String title;
  final List<StepData> steps;

  JobCard(this.title, this.steps);
}

class JobCardsCubit extends Cubit<List<JobCard>> {
  JobCardsCubit() : super([]);

  void addNew(JobCard newCard) => emit([...state, newCard]);
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
