part of 'app_theme_bloc.dart';



enum ThemeStatus {light,dark}

extension ThemeStatusX on ThemeStatus{
  bool get isLight => this == ThemeStatus.light;
  bool get isDark => this == ThemeStatus.dark;
}


class AppThemeState extends Equatable{
  final ThemeStatus state;
  const AppThemeState(this.state);
  @override
  List<Object?> get props => [state];


  AppThemeState copyWith({
    required ThemeStatus value
  }) => AppThemeState(value);

}