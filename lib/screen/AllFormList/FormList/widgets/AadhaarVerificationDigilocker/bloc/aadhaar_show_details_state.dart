import 'package:equatable/equatable.dart';
import 'package:v_verify/screen/AllFormList/FormList/widgets/AadhaarVerificationDigilocker/model/pan_show_details_model.dart';

class AadhaarVerificationShowState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AadhaarVerificationShowInitialState
    extends AadhaarVerificationShowState {}

class AadhaarVerificationShowLoadingState
    extends AadhaarVerificationShowState {}

class AadhaarVerificationShowSuccessState extends AadhaarVerificationShowState {
  final PanVerificationShowModel aadhaarShowModel;

  AadhaarVerificationShowSuccessState(this.aadhaarShowModel);

  @override
  List<Object?> get props => [aadhaarShowModel];
}

class AadhaarVerificationShowErrorState extends AadhaarVerificationShowState {
  final String message;

  AadhaarVerificationShowErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
