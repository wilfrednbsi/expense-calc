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

// class AppThemeInitial extends AppThemeState {
//   final ThemeStatus state;
//   AppThemeInitial(this.state);
//   @override
//   List<Object?> get props => [state];
// }


// class CategoryState extends Equatable {
//   const CategoryState({
//     this.status = CategoryStatus.initial,
//     List<Genre>? categories,
//     int idSelected = 0,
//   })  : categories = categories ?? const [],
//         idSelected = idSelected;
//
//   final List<Genre> categories;
//   final CategoryStatus status;
//   final int idSelected;
//
//   @override
//   List<Object?> get props => [status, categories, idSelected];
//
//   CategoryState copyWith({
//     List<Genre>? categories,
//     CategoryStatus? status,
//     int? idSelected,
//   }) {
//     return CategoryState(
//       categories: categories ?? this.categories,
//       status: status ?? this.status,
//       idSelected: idSelected ?? this.idSelected,
//     );
//   }
// }
