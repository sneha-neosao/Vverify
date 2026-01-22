import 'package:equatable/equatable.dart';
import '../Models/police_station_city_id_model.dart';
import '../Models/police_station_id_model.dart';

class PoliceStationIdState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PoliceStationIdInitialState extends PoliceStationIdState {}

class PoliceStationIdLoadingState extends PoliceStationIdState {}

class PoliceStationIdSuccessState extends PoliceStationIdState {
  final PoliceStationIdModel policeStationIdModel;

  PoliceStationIdSuccessState(this.policeStationIdModel);

  @override
  List<Object?> get props => [policeStationIdModel];
}

class PoliceStationIdErrorState extends PoliceStationIdState {
  String message;

  PoliceStationIdErrorState(this.message);

  @override
  List<Object?> get props => [message];
}


class PoliceStationCityIdState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PoliceStationCityIdInitialState extends PoliceStationCityIdState {}

class PoliceStationCityIdLoadingState extends PoliceStationCityIdState {}

class PoliceStationCityIdSuccessState extends PoliceStationCityIdState {
  final PoliceStationCityIdModel policeStationCityIdModel;

  PoliceStationCityIdSuccessState(this.policeStationCityIdModel);

  @override
  List<Object?> get props => [policeStationCityIdModel];
}

class PoliceStationCityIdErrorState extends PoliceStationCityIdState {
  String message;

  PoliceStationCityIdErrorState(this.message);

  @override
  List<Object?> get props => [message];
}