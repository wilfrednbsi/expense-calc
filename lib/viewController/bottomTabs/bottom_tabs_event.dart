part of 'bottom_tabs_bloc.dart';

abstract class BottomTabsEvent extends Equatable {
  const BottomTabsEvent();
}

class ChangeTab extends BottomTabsEvent{
  final int index;

  const ChangeTab({required this.index});

  @override
  // TODO: implement props
  List<Object?> get props => [index];
}
