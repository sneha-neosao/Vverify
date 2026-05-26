import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/Model/entity_data_model.dart';

sealed class EntityServicesState {}

class EntityServicesInitialState extends EntityServicesState {}

class EntityServicesLoadingState extends EntityServicesState {}

class EntityServicesSuccessState extends EntityServicesState {
  final EntityDataModel model;
  EntityServicesSuccessState(this.model);
}

class EntityServicesErrorState extends EntityServicesState {}
