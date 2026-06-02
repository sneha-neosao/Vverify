import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import '../Model/bank_account_model.dart';
import 'bank_details_state.dart';

class BankDetailsCubit extends Cubit<BankDetailsState> {
  final ApiService _apiService;

  BankDetailsCubit(this._apiService) : super(BankDetailsInitial());

  Future<void> fetchBankDetails(
      {required String token, required String uid}) async {
    emit(BankDetailsLoading());
    try {
      final response =
          await _apiService.bankVerificationShowData(token: token, uid: uid);
      if (response.statusCode == 200) {
        final model = ShowBankDataModel.fromJson(response.data);
        if (model.data != null) {
          emit(BankDetailsSuccess(model.data!));
        } else {
          emit(BankDetailsError("No data found"));
        }
      } else {
        emit(BankDetailsError(
            response.data['message'] ?? "Failed to fetch data"));
      }
    } catch (e) {
      emit(BankDetailsError(e.toString()));
    }
  }
}
