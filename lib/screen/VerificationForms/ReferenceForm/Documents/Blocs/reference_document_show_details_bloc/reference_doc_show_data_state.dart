import 'package:equatable/equatable.dart';

import '../../Models/reference_doc_show_data_model.dart';

class ReferenceDocShowDataState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReferenceDocShowDataInitialState extends ReferenceDocShowDataState {}

class ReferenceDocShowDataLoadingState extends ReferenceDocShowDataState {}

class ReferenceDocShowDataSuccessState extends ReferenceDocShowDataState {
  final ReferenceDocShowDataModel referenceDocShowDataModel;

  ReferenceDocShowDataSuccessState(this.referenceDocShowDataModel);

  @override
  List<Object?> get props => [referenceDocShowDataModel];
}

class ReferenceDocShowDataErrorState extends ReferenceDocShowDataState {
  String message;

  ReferenceDocShowDataErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
