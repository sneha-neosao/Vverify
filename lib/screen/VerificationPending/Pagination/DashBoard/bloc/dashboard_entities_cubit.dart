import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/Model/dashboard_entities_model.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/dashboard_entities_state.dart';

class DashboardEntitiesCubit extends Cubit<DashboardEntitiesState> {
  final ApiService apiService;

  DashboardEntitiesCubit(this.apiService) : super(DashboardEntitiesInitialState());

  Future<void> getDashboardEntities({
    required String token,
    required String customerId,
  }) async {
    emit(DashboardEntitiesLoadingState());
    try {
      final response = await apiService.dashboardAllEntities(
        token: token,
        customer_id: customerId,
      );

      if (response.data != null) {
        final model = DashboardEntitiesModel.fromJson(response.data);
        if (model.status == 200) {
          emit(DashboardEntitiesSuccessState(model));
        } else {
          emit(DashboardEntitiesErrorState());
        }
      } else {
        emit(DashboardEntitiesErrorState());
      }
    } catch (e) {
      emit(DashboardEntitiesErrorState());
    }
  }
}
