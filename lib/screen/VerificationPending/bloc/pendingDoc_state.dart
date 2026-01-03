import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/Home%20screen/model/home_Screen_model.dart';

import '../model/pendingDoc_model.dart';

class PendingDocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PendingDocInitialState extends PendingDocState {}

class PendingDocLoadingState extends PendingDocState {}

class PendingDocSuccessState extends PendingDocState {
  final PendingDocModel pendingDocModel;

  PendingDocSuccessState(this.pendingDocModel);

  @override
  List<Object?> get props => [pendingDocModel];
}

class PendingDocErrorState extends PendingDocState {
  String message;

  PendingDocErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
