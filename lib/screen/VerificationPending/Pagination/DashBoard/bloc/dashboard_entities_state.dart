import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/Model/dashboard_entities_model.dart';

sealed class DashboardEntitiesState {}

class DashboardEntitiesInitialState extends DashboardEntitiesState {}

class DashboardEntitiesLoadingState extends DashboardEntitiesState {}

class DashboardEntitiesSuccessState extends DashboardEntitiesState {
  final DashboardEntitiesModel model;
  DashboardEntitiesSuccessState(this.model);
}

class DashboardEntitiesErrorState extends DashboardEntitiesState {}
