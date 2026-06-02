import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../apiServices/api_services.dart';
import '../Model/court_verification_model.dart';
import 'court_details_state.dart';

class CourtDetailsCubit extends Cubit<CourtDetailsState> {
  final ApiService _apiService;

  CourtDetailsCubit(this._apiService) : super(CourtDetailsInitial());

  Future<void> fetchCourtDetails({
    required String token,
    required String uid,
  }) async {
    emit(CourtDetailsLoading());
    try {
      final response = await _apiService.courtVerificationShowData(
        token: token,
        uid: uid,
      );

      if (response.data != null && response.data['status'] == 200) {
        final model = ShowCourtDataModel.fromJson(response.data);
        if (model.data != null) {
          emit(CourtDetailsSuccess(model.data!));
        } else {
          emit(CourtDetailsError("Data is empty"));
        }
      } else {
        emit(CourtDetailsError(
            response.data['message'] ?? "Failed to fetch details"));
      }
    } catch (e) {
      emit(CourtDetailsError(e.toString()));
    }
  }
}
