import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_verify/apiServices/api_services.dart';
import '../Model/reference_check_details_model.dart';
import 'reference_details_state.dart';

class ReferenceDetailsCubit extends Cubit<ReferenceDetailsState> {
  final ApiService _apiService;

  ReferenceDetailsCubit(this._apiService) : super(ReferenceDetailsInitial());

  Future<void> fetchReferenceDetails({
    required String token,
    required String uid,
  }) async {
    emit(ReferenceDetailsLoading());
    try {
      final response = await _apiService.ReferenceCheckDetailsView(
        token: token,
        uid: uid,
      );

      if (isClosed) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final ReferenceCheckDetailsModel model =
            ReferenceCheckDetailsModel.fromJson(response.data);

        if (model.status == 200 && model.data != null) {
          emit(ReferenceDetailsSuccess(model.data!));
        } else {
          emit(ReferenceDetailsError(
              model.message ?? "Failed to fetch details"));
        }
      } else {
        emit(ReferenceDetailsError("Failed to fetch details"));
      }
    } catch (e) {
      if (isClosed) return;
      emit(ReferenceDetailsError("Error fetching details: $e"));
    }
  }
}
