import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_calc/components/constants/AppTheme.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'app_theme_event.dart';
part 'app_theme_state.dart';

class AppThemeBloc extends Bloc<AppThemeEvent, AppThemeState> {
  AppThemeBloc() : super(const AppThemeState(ThemeStatus.light)) {
    on<OnLightTheme>((event, emit) {
      _onEmit(emit, ThemeStatus.light);
    });

    on<OnDarkTheme>((event, emit) {
      _onEmit(emit, ThemeStatus.dark);
    });
  }

  ThemeData get getThemeData {
    return state.state == ThemeStatus.light ? AppTheme.light : AppTheme.dark;
  }

  void _onEmit(Emitter<AppThemeState> emit, ThemeStatus value){
    emit(state.copyWith(value: value),);
  }
}
