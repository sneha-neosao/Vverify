import '../../Models/all_entities_model.dart';

abstract class AllEntitiesState {}

class AllEntitiesInitialState extends AllEntitiesState {}

class AllEntitiesLoadingState extends AllEntitiesState {}

class AllEntitiesSuccessState extends AllEntitiesState {
  final AllEntitiesModel allEntitiesModel;
  AllEntitiesSuccessState(this.allEntitiesModel);
}

class AllEntitiesErrorState extends AllEntitiesState {
  final String message;
  AllEntitiesErrorState(this.message);
}
