import 'package:expense_calc/components/constants/AppFonts.dart';
import 'package:expense_calc/components/coreComponents/TextView.dart';
import 'package:expense_calc/components/widgets/dialog/FailureMessageDialog.dart';
import 'package:expense_calc/presentation/auth/ForgotPasswordView.dart';
import 'package:expense_calc/presentation/auth/SignupView.dart';
import 'package:expense_calc/presentation/bottomTabs/BottomTabs.dart';
import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:expense_calc/viewController/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/constants/AppStrings.dart';
import '../../components/constants/TextStyles.dart';
import '../../components/coreComponents/AppButton.dart';
import '../../components/coreComponents/EditText.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // onCreate();
  }

  onCreate() {
    final state = BlocProvider.of<LoginBloc>(context, listen: false);
    final errorState = state.state as LoginError;
    emailCtrl.text = errorState.error;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: AppFonts.s20),
        child: loginForm(
          onLogin: (){
            context.pushAndClearNavigator(const BottomTabs());
          },
        ),
      ),
    );
  }


  Widget loginForm({required Function()onLogin}) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if(state is LoginLoading){
          context.load;
        }else if (state is LoginSuccess) {
          context.stopLoader;
          onLogin();
        }else if (state is LoginError) {
          context.stopLoader;
          context.openDialog(FailureMessageDailog(
              message: state.error,
            onTap: () => context.stopLoader,
          ));
        }else if(state is LoginFormValidationError){
          context.stopLoader;
        }
      },
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextView(
              text: AppStrings.log_in_toYourAccount,
              textStyle: TextStyles.semiBold16Black,
            ),

            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                var error = "";
                if (state is LoginFormValidationError) {
                  error = state.email;
                }
                return EditText(
                    margin: const EdgeInsets.symmetric(vertical: AppFonts.s20),
                    hint: AppStrings.enterYourEmailAddress,
                    controller: emailCtrl,
                    error: error
                );
              },
            ),
            BlocBuilder<LoginBloc, LoginState>(
              builder: (context, state) {
                var error = "";
                if (state is LoginFormValidationError) {
                  error = state.password;
                }
                return EditText(
                  hint: AppStrings.enterYourPassword,
                  isPassword: true,
                  controller: passwordCtrl,
                  error: error,
                );
              },
            ),
            AppButton(
              onTap: () => context.read<LoginBloc>().add(DoLoginEvent(emailCtrl.text, passwordCtrl.text)),
              margin: const EdgeInsets.symmetric(vertical: AppFonts.s40),
              label: AppStrings.login,
              labelStyle: TextStyles.medium14White,
            ),
            Row(
              children: [
                const TextView(
                  text: AppStrings.ddntHaveAccount,
                  textStyle: TextStyles.medium14Black,
                ),
                TextView(
                  onTap: () => context.pushNavigator(const SignupView()),
                  text: AppStrings.createNew,
                  textStyle: TextStyles.semiBold14Primary,
                )
              ],
            ),
            TextView(
              onTap: () =>
                  context.pushNavigator(const ForgotPasswordView()),
              text: AppStrings.forgotPassword,
              textStyle: TextStyles.semiBold14Primary,
              margin: const EdgeInsets.only(top: AppFonts.s10),
            )
          ],
        );
      },
    );
  }
}
