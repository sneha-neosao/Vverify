import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import 'package:v_verify/screen/ServicesAndPrice/Blocs/service_prices_bloc/service_prices_state.dart';

import '../../Models/service_prices_model.dart';

class ServicePriceCubit extends Cubit<ServicePriceState> {
  ApiService _apiService;

  ServicePriceCubit(this._apiService) : super(ServicePriceInitialState());

  void getServicePrice({required String token, required String type_id,required String entity_id}) async {
    emit(ServicePriceLoading());
    try {
      final response =
          await _apiService.getServicesPricing(token: token, type_id: type_id, entity_id: entity_id);

      if (response.data != null && response.data.containsKey("status")) {
        final ServicePriceModel servicePriceModel =
            ServicePriceModel.fromJson(response.data);
        final status = response.data["status"];
        if (status == 200) {
          emit(ServicePriceSuccess(servicePriceModel));
        } else if (status == 500) {
          final errorMessage =
              response.data['message'] ?? 'Unknown error occurred.';
          emit(ServicePriceError(errorMessage));
        } else {
          emit(ServicePriceError('failed with status: $status'));
        }
      } else {
        emit(ServicePriceError('Invalid response data.'));
      }
    } catch (e) {
      emit(ServicePriceError('An error occurred: ${e.toString()}'));
    }
  }
}

class SelectItemCubit extends Cubit<List<bool>> {
  SelectItemCubit() : super([]);

  final List<bool> _selectedItems = List.generate(8, (index) => false);

  void selectItem({required int index}) {
    _selectedItems[index] = !_selectedItems[index];
  }
}
