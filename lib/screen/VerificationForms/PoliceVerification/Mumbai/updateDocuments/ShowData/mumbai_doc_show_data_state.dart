import 'package:equatable/equatable.dart';

import '../../../NonMumbai/UpdateDocument/showdata/model/non_mumbai_show_data_model.dart';
import '../../UpdateForm/showDetails/Model/MumbaiShowData_model.dart';
import 'Model/mumbai_doc_show_data_model.dart';

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
