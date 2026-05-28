import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'all_entities_state.dart';
import '../../Models/all_entities_model.dart';

class AllEntitiesCubit extends Cubit<AllEntitiesState> {
  final ApiService _apiService;

  AllEntitiesCubit(this._apiService) : super(AllEntitiesInitialState());

  void getAllEntities(
      {required String token, required String customer_id}) async {
    emit(AllEntitiesLoadingState());
    try {
      final response = await _apiService.dashboardAllEntities(
          token: token, customer_id: customer_id);
      if (response.data != null && response.data.containsKey("status")) {
        final AllEntitiesModel model = AllEntitiesModel.fromJson(response.data);
        if (model.status == 200) {
          emit(AllEntitiesSuccessState(model));
        } else {
          emit(AllEntitiesErrorState(
              model.message ?? 'Failed to fetch all-entities'));
        }
      } else {
        emit(AllEntitiesErrorState('Invalid response data'));
      }
    } catch (e) {
      emit(AllEntitiesErrorState('An error occurred: $e'));
    }
  }
}
