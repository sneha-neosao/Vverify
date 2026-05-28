import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../apiServices/api_services.dart';
import 'Models/address_save_model.dart';
import 'name_address_store_state.dart';

class NameAddressStoreCubit extends Cubit<NameAddressStoreState> {
  final ApiService _apiService;

  NameAddressStoreCubit(this._apiService) : super(NameAddressStoreInitial());

  Future<void> submitNameAddress({
    required String token,
    required String customerId,
    required NameAddressVerificationModel model,
  }) async {
    emit(NameAddressStoreLoading());
    try {
      final response = await _apiService.NameAddressStore(
        token: token,
        customer_id: customerId,
        nameAddressVerificationModel: model,
      );

      if (response.data != null && response.data is Map) {
        final responseData = Map<String, dynamic>.from(response.data);
        if (responseData["status"] == 200) {
          emit(NameAddressStoreSuccess(responseData));
        } else {
          final errorMessage = responseData["message"] ??
              "An error occurred while saving address details.";
          emit(NameAddressStoreFailure(errorMessage.toString()));
        }
      } else {
        emit(const NameAddressStoreFailure(
            "Invalid response format received from server."));
      }
    } catch (e) {
      emit(NameAddressStoreFailure(e.toString()));
    }
  }
}
