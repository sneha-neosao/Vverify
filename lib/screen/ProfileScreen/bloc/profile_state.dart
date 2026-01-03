import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/ProfileScreen/model/profile_model.dart';

class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitialState extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final ProfileModel profileModel;

  ProfileSuccess(this.profileModel);

  @override
  List<Object?> get props => [profileModel];
}

class ProfileError extends ProfileState {
  final String errorMessage;

  ProfileError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
