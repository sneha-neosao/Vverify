import 'package:equatable/equatable.dart';
import '../model/collage_name_model.dart';

class CollageNameState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CollageNameInitialState extends CollageNameState {}

class CollageNameLoadingState extends CollageNameState {}

class CollageNameSuccessState extends CollageNameState {
  final CollageNameModel collageNameModel;

  CollageNameSuccessState(this.collageNameModel);

  @override
  List<Object?> get props => [collageNameModel];
}

class CollageNameErrorState extends CollageNameState {
  String message;

  CollageNameErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
