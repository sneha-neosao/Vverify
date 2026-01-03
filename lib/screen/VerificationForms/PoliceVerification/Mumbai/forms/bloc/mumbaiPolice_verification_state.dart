import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/Home%20screen/model/home_Screen_model.dart';

class MumbaiVerificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MumbaiVerificationInitialState extends MumbaiVerificationState {}

class MumbaiVerificationLoadingState extends MumbaiVerificationState {}

class MumbaiVerificationSuccessState extends MumbaiVerificationState {
  final Map<String,dynamic> data;

  MumbaiVerificationSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class MumbaiVerificationErrorState extends MumbaiVerificationState {
  String message;

  MumbaiVerificationErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
