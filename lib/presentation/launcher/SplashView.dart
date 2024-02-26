import 'package:expense_calc/presentation/bottomTabs/BottomTabs.dart';
import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/constants/AppColors.dart';
import '../../components/constants/TextStyles.dart';
import '../../components/coreComponents/TextView.dart';
import '../../viewController/login/login_bloc.dart';
import '../auth/LoginView.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {

  void onNextPage(bool isAuth){
    Future.delayed(const Duration(seconds: 3),(){
      context.replaceNavigator(isAuth ? const BottomTabs() :const LoginView());
    });
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if(state is LoginIsAuthenticated){
          onNextPage(state.state);
        }
      },
      builder: (context, state) {
        return const Scaffold(
            backgroundColor: AppColors.primaryColor,
            body: Center(child: TextView(text: 'Expense\nCalculator',
              textAlign: TextAlign.center,
              textStyle: TextStyles.bold30White,))
        );
      },
    );
  }
}
