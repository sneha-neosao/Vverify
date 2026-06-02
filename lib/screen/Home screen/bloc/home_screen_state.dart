import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/Home%20screen/model/home_Screen_model.dart';

class HomeScreenState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeScreenInitialState extends HomeScreenState {}

class HomeScreenLoadingState extends HomeScreenState {}

class HomeScreenSuccessState extends HomeScreenState {
  final HomeScreenModel homeScreenModel;

  HomeScreenSuccessState(this.homeScreenModel);

  @override
  List<Object?> get props => [homeScreenModel];
}

class HomeScreenErrorState extends HomeScreenState {
  String message;

  HomeScreenErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class UserTermsConditionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserTermsConditionInitialState extends UserTermsConditionState {}

class UserTermsConditionLoadingState extends UserTermsConditionState {}

class UserTermsConditionSuccessState extends UserTermsConditionState {
  final Map<String, dynamic> data;

  UserTermsConditionSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class UserTermsConditionErrorState extends UserTermsConditionState {
  String message;

  UserTermsConditionErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
