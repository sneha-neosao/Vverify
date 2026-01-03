import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/Home%20screen/model/home_Screen_model.dart';

class NonMumbaiVerificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NonMumbaiVerificationInitialState extends NonMumbaiVerificationState {}

class NonMumbaiVerificationLoadingState extends NonMumbaiVerificationState {}

class NonMumbaiVerificationSuccessState extends NonMumbaiVerificationState {
  final Map<String,dynamic> data;

  NonMumbaiVerificationSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class NonMumbaiVerificationErrorState extends NonMumbaiVerificationState {
  String message;

  NonMumbaiVerificationErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
