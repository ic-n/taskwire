import 'package:flutter_bloc/flutter_bloc.dart';

class JobCard {
  String title = "Refresh docker";
  String body = "sudo apt update -y\nsudo apt upgade -y docker";
}

class JobCardsCubit extends Cubit<List<JobCard>> {
  JobCardsCubit() : super([]);

  void addNew() => emit([...state, JobCard()]);
}
