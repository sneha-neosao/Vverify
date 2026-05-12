import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'bank_account_state.dart';

class BankAccountCubit extends Cubit<BankAccountState> {
  final ApiService _apiService;

  BankAccountCubit(this._apiService) : super(BankAccountInitialState());

  Future<void> bankVerificationForm({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    emit(BankAccountLoadingState());
    try {
      final response = await _apiService.bankVerificationForm(token: token, data: data);
      if (response.statusCode == 200) {
        emit(BankAccountSuccessState(response.data));
      } else {
        emit(BankAccountErrorState(response.data['message'] ?? "Something went wrong"));
      }
    } catch (e) {
      emit(BankAccountErrorState(e.toString()));
    }
  }

  Future<void> updateBankVerificationForm({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    emit(BankAccountLoadingState());
    try {
      final response = await _apiService.bankVerificationUpdate(token: token, data: data);
      if (response.statusCode == 200) {
        emit(BankAccountSuccessState(response.data));
      } else {
        emit(BankAccountErrorState(response.data['message'] ?? "Something went wrong"));
      }
    } catch (e) {
      emit(BankAccountErrorState(e.toString()));
    }
  }
}
