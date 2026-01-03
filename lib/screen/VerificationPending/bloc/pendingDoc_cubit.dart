import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/VerificationPending/bloc/pendingDoc_state.dart';

import '../model/pendingDoc_model.dart';

class PendingDocCubit extends Cubit<PendingDocState> {
  ApiService _apiService;

  PendingDocCubit(this._apiService) : super(PendingDocInitialState());

  Future<void> getPendingDoc(
      {required String token,
      required int customerId,
      required int page,
      required int limit,
      String? status}) async {
    emit(PendingDocLoadingState());
    try {
      final response = await _apiService.verifyRequestList(
          token: token,
          customer_id: customerId,
          page: page,
          limit: limit,
          status: status);

      if (response.data != null && response.data.containsKey("status")) {
        final PendingDocModel pendingDocModel =
            PendingDocModel.fromJson(response.data);
        if (pendingDocModel.status == 200) {
          emit(PendingDocSuccessState(pendingDocModel));
        } else if (pendingDocModel.status == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(PendingDocErrorState(errorMessage));
        } else {
          emit(PendingDocErrorState('${pendingDocModel.message}'));
        }
      } else {
        emit(PendingDocErrorState('Invalid response data.'));
      }
    } catch (e) {
      emit(PendingDocErrorState('An error occurred:$e'));
    }
  }
}

class IsPressedCubit extends Cubit<int> {
  IsPressedCubit() : super(0);

  void isPressed(index) {
    emit(index);
  }
}
