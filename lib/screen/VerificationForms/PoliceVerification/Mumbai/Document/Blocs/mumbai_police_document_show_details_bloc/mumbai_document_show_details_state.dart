import 'package:equatable/equatable.dart';

import '../../../../NonMumbai/Document/Models/non_mumbai_show_details_model.dart';
import '../../../Form/Models/mumbai_police_show_details_model.dart';
import '../../Models/mumbai_document_show_details_model.dart';

class MumbaiDocShowDataState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MumbaiDocShowDataInitialState extends MumbaiDocShowDataState {}

class MumbaiDocShowDataLoadingState extends MumbaiDocShowDataState {}

class MumbaiDocShowDataSuccessState extends MumbaiDocShowDataState {
  final MumbaiDocShowDataModel mumbaiDocShowDataModel;

  MumbaiDocShowDataSuccessState(this.mumbaiDocShowDataModel);

  @override
  List<Object?> get props => [mumbaiDocShowDataModel];
}

class MumbaiDocShowDataErrorState extends MumbaiDocShowDataState {
  String message;

  MumbaiDocShowDataErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
