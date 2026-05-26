import 'package:flutter_bloc/flutter_bloc.dart';

class PendingDocFilterState {
  final String? status;
  final int? entityId;
  final int? groupId;

  PendingDocFilterState({
    this.status,
    this.entityId,
    this.groupId,
  });
}

class PendingDocNavigationCubit extends Cubit<PendingDocFilterState> {
  PendingDocNavigationCubit() : super(PendingDocFilterState());

  void selectCategory({
    required String? status,
    required int? entityId,
    required int? groupId,
  }) {
    emit(PendingDocFilterState(
      status: status,
      entityId: entityId,
      groupId: groupId,
    ));
  }

  void clear() {
    emit(PendingDocFilterState(
      status: null,
      entityId: null,
      groupId: null,
    ));
  }
}
