import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_tabs_event.dart';
part 'bottom_tabs_state.dart';

class BottomTabsBloc extends Bloc<BottomTabsEvent, BottomTabsState> {
  BottomTabsBloc() : super(const BottomTabsState(index: 0)) {
    on<BottomTabsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ChangeTab>(_onChangeTab);
  }

  FutureOr<void> _onChangeTab(ChangeTab event, Emitter<BottomTabsState> emit) {
    emit(BottomTabsState(index: event.index));
  }
}
