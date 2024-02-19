part of 'app_theme_bloc.dart';

@immutable
abstract class AppThemeEvent extends Equatable{
  @override
  List<Object?> get props => [];
}


class OnLightTheme extends AppThemeEvent{

}

class OnDarkTheme extends AppThemeEvent{

}




// abstract class ThemeEvent {}
//
// class ToggleTheme extends ThemeEvent {}