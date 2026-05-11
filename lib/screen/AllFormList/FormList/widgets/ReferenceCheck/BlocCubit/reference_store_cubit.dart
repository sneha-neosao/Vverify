import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import '../Model/reference_store_model.dart';
import '../Model/verify_request_response_model.dart';
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
          emit(ReferenceStoreSuccess(
              response.data['message'] ?? 'Reference stored successfully'));
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

  Future<void> fetchReferenceDetails({
    required String token,
    required String requestId,
  }) async {
    emit(ReferenceDetailsLoading());
    try {
      final response = await _apiService.VerifyDetailsView(
        token: token,
        request_id: requestId,
      );

      if (response.data != null && response.data['status'] == 200) {
        final VerifyRequestResponseModel model =
            VerifyRequestResponseModel.fromJson(response.data);

        final referenceData = model.data?.referenceCheckVerification;
        if (referenceData != null) {
          emit(ReferenceDetailsSuccess(referenceData));
        } else {
          emit(ReferenceDetailsInitial());
        }
      } else {
        emit(ReferenceDetailsError("Failed to fetch details"));
      }
    } catch (e) {
      emit(ReferenceDetailsError("Error fetching details: $e"));
    }
  }
}
