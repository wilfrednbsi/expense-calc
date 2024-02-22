import 'package:expense_calc/viewController/appTheme/app_theme_bloc.dart';
import 'package:expense_calc/viewController/login/login_bloc.dart';
import 'package:expense_calc/viewController/signup/sign_up_bloc.dart';
import 'package:flutter/material.dart';
import 'presentation/launcher/SplashView.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers,
      child: BlocBuilder<AppThemeBloc, AppThemeState>(
        builder: (context, state) =>
            MaterialApp(
              title: 'Flutter Demo',
              theme: BlocProvider.of<AppThemeBloc>(context).getThemeData,
              darkTheme: BlocProvider.of<AppThemeBloc>(context).getThemeData,
              themeMode: state.state == ThemeStatus.light ? ThemeMode.light : ThemeMode.dark,
              debugShowCheckedModeBanner: false,
              home: const SplashView(),
            ),
      ),
    );
  }
}

List<SingleChildWidget> providers = [
  BlocProvider(create: (context) => AppThemeBloc()),
  BlocProvider(create: (context) => LoginBloc()),
  BlocProvider(create: (context) => SignUpBloc()),
];





