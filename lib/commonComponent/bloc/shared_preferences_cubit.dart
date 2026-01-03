import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenCubit extends Cubit<String> {
  TokenCubit() : super("");

  Future<void>  getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    emit(token!);
  }
}

class IdCubit extends Cubit<String> {
  IdCubit() : super("");

  Future<void> getId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = prefs.getString('id');

    emit(id!);
  }
}

class UserTypeId extends Cubit<String> {
  UserTypeId() : super("");

  Future<void> getUserTypeId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userTypeId = prefs.getString('userType');

    emit(userTypeId!);
  }
}


