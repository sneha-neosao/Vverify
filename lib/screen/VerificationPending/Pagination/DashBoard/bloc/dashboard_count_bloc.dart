import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/Model/dashboard_count_model.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/dashboard_count_state.dart';

class DashboardCountBloc extends Cubit<DashboardCountState> {
  final ApiService apiService;

  DashboardCountBloc(this.apiService) : super(DashboardCountInitialState());

  Future<void> getDashboardCount({
    required String token,
    required String customerId,
  }) async {
    emit(DashboardCountLoadingState());
    try {
      final response = await apiService.dashboardCount(
        token: token,
        customer_id: customerId,
      );

      if (response.data != null) {
        final model = DashboardCountModel.fromJson(response.data);
        if (model.status == 200) {
          emit(DashboardCountSuccessState(model));
        } else {
          emit(DashboardCountErrorState());
        }
      } else {
        emit(DashboardCountErrorState());
      }
    } catch (e) {
      emit(DashboardCountErrorState());
    }
  }
}
