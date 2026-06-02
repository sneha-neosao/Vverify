import 'package:equatable/equatable.dart';

class PushNotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PushNotificationInitialState extends PushNotificationState {}

class PushNotificationLoadingState extends PushNotificationState {}

class PushNotificationSuccessState extends PushNotificationState {
  final Map<String, dynamic> data;

  PushNotificationSuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

class PushNotificationErrorState extends PushNotificationState {
  String message;

  PushNotificationErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
