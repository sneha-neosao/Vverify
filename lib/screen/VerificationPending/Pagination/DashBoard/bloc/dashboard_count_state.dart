import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/Model/dashboard_count_model.dart';

sealed class DashboardCountState {}

class DashboardCountInitialState extends DashboardCountState {}

class DashboardCountLoadingState extends DashboardCountState {}

class DashboardCountSuccessState extends DashboardCountState {
  final DashboardCountModel? model;
  DashboardCountSuccessState(this.model);
}

class DashboardCountErrorState extends DashboardCountState {}
