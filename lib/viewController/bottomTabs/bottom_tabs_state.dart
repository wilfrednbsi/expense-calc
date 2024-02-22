part of 'bottom_tabs_bloc.dart';

class BottomTabsState extends Equatable {
  final int index;
  const BottomTabsState({required this.index});

  @override
  List<Object?> get props => [index];
}
