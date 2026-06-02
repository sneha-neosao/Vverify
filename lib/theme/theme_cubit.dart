import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'theme_data.dart';

class ThemeCubit extends Cubit<AppTheme> with WidgetsBindingObserver {
  ThemeCubit() : super(AppTheme.light) {
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    emit(brightness == Brightness.dark ? AppTheme.dark : AppTheme.light);

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }

  @override
  void didChangePlatformBrightness() {
    final brightness = WidgetsBinding.instance.window.platformBrightness;
    emit(brightness == Brightness.dark ? AppTheme.dark : AppTheme.light);
  }

  void toggleTheme() {
    emit(state == AppTheme.light ? AppTheme.dark : AppTheme.light);
  }

  void setLightMode() {
    emit(AppTheme.light);
  }

  void setDarkMode() {
    emit(AppTheme.dark);
  }
}
