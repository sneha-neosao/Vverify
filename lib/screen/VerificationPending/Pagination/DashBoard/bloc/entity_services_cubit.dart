import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/Model/entity_data_model.dart';
import 'package:v_verify/screen/VerificationPending/Pagination/DashBoard/bloc/entity_services_state.dart';

class EntityServicesCubit extends Cubit<EntityServicesState> {
  final ApiService apiService;

  EntityServicesCubit(this.apiService) : super(EntityServicesInitialState());

  Future<void> getEntityServices({
    required String token,
    required String customerId,
    required String entityId,
  }) async {
    emit(EntityServicesLoadingState());
    try {
      final response = await apiService.entitiesData(
        token: token,
        customer_id: customerId,
        entity_id: entityId,
      );

      if (response.data != null) {
        final model = EntityDataModel.fromJson(response.data);
        if (model.status == 200) {
          emit(EntityServicesSuccessState(model));
        } else {
          emit(EntityServicesErrorState());
        }
      } else {
        emit(EntityServicesErrorState());
      }
    } catch (e) {
      emit(EntityServicesErrorState());
    }
  }
}
