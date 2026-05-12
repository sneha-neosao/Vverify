import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import '../Model/reference_store_model.dart';
import 'reference_store_state.dart';

class ReferenceStoreCubit extends Cubit<ReferenceStoreState> {
  final ApiService _apiService;

  ReferenceStoreCubit(this._apiService) : super(ReferenceStoreInitial());

  Future<void> storeReferenceForm({
    required String token,
    required ReferenceStoreModel model,
  }) async {
    emit(ReferenceStoreLoading());
    try {
      final response = await _apiService.referenceFormStore(
        token: token,
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final status = response.data['status'];
        if (status == 200 || status == "200") {
          final uid = response.data['data']?['uid'];
          emit(ReferenceStoreSuccess(
              response.data['message'] ?? 'Reference stored successfully',
              uid: uid?.toString()));
        } else {
          emit(ReferenceStoreError(
              response.data['message'] ?? 'Failed to store reference'));
        }
      } else {
        emit(ReferenceStoreError('Server error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ReferenceStoreError('An error occurred: $e'));
    }
  }

  Future<void> updateReferenceForm({
    required String token,
    required ReferenceStoreModel model,
  }) async {
    emit(ReferenceStoreLoading());
    try {
      final response = await _apiService.referenceFormUpdate(
        token: token,
        data: model.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final status = response.data['status'];
        if (status == 200 || status == "200") {
          final uid = response.data['data']?['uid'];
          emit(ReferenceStoreSuccess(
              response.data['message'] ?? 'Reference updated successfully',
              uid: uid?.toString()));
        } else {
          emit(ReferenceStoreError(
              response.data['message'] ?? 'Failed to update reference'));
        }
      } else {
        emit(ReferenceStoreError('Server error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(ReferenceStoreError('An error occurred: $e'));
    }
  }
}
