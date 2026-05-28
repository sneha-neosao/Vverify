import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import '../Model/pan_verification_model.dart';
import 'pan_verification_state.dart';

class PanVerificationCubit extends Cubit<PanVerificationState> {
  final ApiService _apiService;

  PanVerificationCubit(this._apiService) : super(PanVerificationInitial());

  Future<void> submitPanVerification({
    required String token,
    required String requestId,
    required String serviceRequestId,
    required String serviceId,
    required String customerId,
    required String documentType,
    required String documentNumber,
  }) async {
    emit(PanVerificationLoading());
    try {
      final response = await _apiService.panVerificationMultipart(
        token: token,
        requestId: requestId,
        serviceRequestId: serviceRequestId,
        serviceId: serviceId,
        customerId: customerId,
        documentType: documentType,
        documentNumber: documentNumber,
      );

      if (response.statusCode == 200) {
        final submitModel = PanVerificationSubmitModel.fromJson(response.data);
        if (submitModel.status == 200) {
          emit(PanVerificationSuccess(submitModel));
        } else {
          emit(PanVerificationFailure(submitModel.message ?? "Submission failed"));
        }
      } else {
        emit(PanVerificationFailure(response.data['message'] ?? "Something went wrong"));
      }
    } catch (e) {
      emit(PanVerificationFailure(e.toString()));
    }
  }

  Future<void> fetchPanDetails({
    required String token,
    required String uid,
  }) async {
    emit(PanShowLoading());
    try {
      final response = await _apiService.panNumberShowData(
        token: token,
        uid: uid,
      );

      if (response.statusCode == 200) {
        final showModel = ShowPanDataModel.fromJson(response.data);
        if (showModel.data != null) {
          emit(PanShowSuccess(showModel.data!));
        } else {
          emit(PanVerificationFailure(showModel.message ?? "No data found"));
        }
      } else {
        emit(PanVerificationFailure(response.data['message'] ?? "Failed to fetch PAN details"));
      }
    } catch (e) {
      emit(PanVerificationFailure(e.toString()));
    }
  }
}
