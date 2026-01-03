import 'package:equatable/equatable.dart';

import '../model/editProfile_model.dart';

abstract class EditProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileSuccess extends EditProfileState {
  final EditProfileModel editProfileModel;

  EditProfileSuccess(this.editProfileModel);

  @override
  List<Object> get props => [editProfileModel];
}

class EditProfileFailure extends EditProfileState {
  final String errorMessage;

  EditProfileFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
