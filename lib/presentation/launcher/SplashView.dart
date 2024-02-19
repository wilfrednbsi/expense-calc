
import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:flutter/material.dart';

import '../../components/constants/AppColors.dart';
import '../../components/constants/TextStyles.dart';
import '../../components/coreComponents/TextView.dart';
import '../auth/LoginView.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onCreate();
  }

  void onCreate(){
    Future.delayed(const Duration(seconds: 3),(){
      context.pushNavigator(const LoginView());
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primaryColor,
      body:  Center(child: TextView(text: 'Expense\nCalculator',
            textAlign: TextAlign.center,
            textStyle: TextStyles.bold30White,))
    );
  }
}
