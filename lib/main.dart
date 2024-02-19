import 'package:expense_calc/viewController/appTheme/app_theme_bloc.dart';
import 'package:flutter/material.dart';
import 'presentation/launcher/SplashView.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppThemeBloc(),
        ),
        // BlocProvider(
        //   create: (context) => SubjectBloc(),
        // ),
      ],
      child: BlocBuilder<AppThemeBloc, AppThemeState>(
        builder: (context, state) =>
            MaterialApp(
              title: 'Flutter Demo',
              theme: BlocProvider.of<AppThemeBloc>(context).getThemeData,
              darkTheme: BlocProvider.of<AppThemeBloc>(context).getThemeData,
              themeMode: state.state == ThemeStatus.light ? ThemeMode.light : ThemeMode.dark,
              // ThemeData(
              //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              //   useMaterial3: true,
              // ),
              debugShowCheckedModeBanner: false,
              home: const SplashView(),
            ),
      ),
    );
  }
}