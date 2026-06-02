import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../apiServices/api_services.dart';
import '../model/credit_report_show_model.dart';
import 'credit_history_show_state.dart';

class CreditHistoryShowCubit extends Cubit<CreditHistoryShowState> {
  final ApiService _apiService;

  CreditHistoryShowCubit(this._apiService)
      : super(CreditHistoryShowInitialState());

  void fetchCreditDetails({
    required String token,
    required String uid,
  }) async {
    emit(CreditHistoryShowLoadingState());
    try {
      final response = await _apiService.showCreditReport(
        token: token,
        uid: uid,
      );

      if (response.data != null && response.data.containsKey("status")) {
        if (response.data["status"] == 200) {
          final model = CreditReportShowModel.fromJson(response.data);
          emit(CreditHistoryShowSuccessState(model));
        } else if (response.data["status"] == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(CreditHistoryShowFailureState(errorMessage));
        } else {
          emit(CreditHistoryShowFailureState(
              '${response.data["status"]} \n ${response.data["message"]}'));
        }
      } else {
        emit(CreditHistoryShowFailureState('Invalid response data.'));
      }
    } catch (e) {
      emit(CreditHistoryShowFailureState('An error occurred: $e'));
    }
  }
}
