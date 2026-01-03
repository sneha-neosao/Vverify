import 'package:equatable/equatable.dart';
import '../model/university_name_state.dart';

class UniversityNameState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UniversityNameInitialState extends UniversityNameState {}

class UniversityNameLoadingState extends UniversityNameState {}

class UniversityNameSuccessState extends UniversityNameState {
  final UniversityNameModel universityNameModel;

  UniversityNameSuccessState(this.universityNameModel);

  @override
  List<Object?> get props => [universityNameModel];
}

class UniversityNameErrorState extends UniversityNameState {
  String message;

  UniversityNameErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
