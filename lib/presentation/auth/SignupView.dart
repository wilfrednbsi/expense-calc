import 'package:expense_calc/components/widgets/dialog/FailureMessageDialog.dart';
import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:expense_calc/viewController/signup/sign_up_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/constants/AppFonts.dart';
import '../../components/constants/AppStrings.dart';
import '../../components/constants/TextStyles.dart';
import '../../components/coreComponents/AppButton.dart';
import '../../components/coreComponents/EditText.dart';
import '../../components/coreComponents/TextView.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confPasswordCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: AppFonts.s20),
        child: form(
          onSuccess: (){
            print('register successfully');
            context.pop();
          }
        ),
      ),
    );
  }


  Widget form({required Function() onSuccess}) {
    return BlocConsumer<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if(state is SignUpLoading){
          context.load;
        }else if(state is SignUpSuccess){
          context.stopLoader;
          onSuccess();
        }else if(state is SignUpFailure){
          context.stopLoader;
          context.openDialog(FailureMessageDailog(message: state.error));
        }else if (state is SignUpFormValidationError){
          context.stopLoader;
        }
      },
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextView(text: AppStrings.createAccount,
              textStyle: TextStyles.semiBold16Black,),
            BlocBuilder<SignUpBloc, SignUpState>(
              builder: (context, state) {
                var error = '';
                if(state is SignUpFormValidationError){
                  error = state.email;
                }
                return EditText(
                    margin: const EdgeInsets.symmetric(vertical: AppFonts.s20),
                    hint: AppStrings.enterYourEmailAddress,
                    controller: emailCtrl,
                  error: error,
                );
              },
            ),
            BlocBuilder<SignUpBloc, SignUpState>(
              builder: (context, state) {
                var error = '';
                if(state is SignUpFormValidationError){
                  error = state.password;
                }
                return EditText(
                  hint: AppStrings.password,
                  controller: passwordCtrl,
                  isPassword: true,
                  error: error,
                );
              },
            ),
            BlocBuilder<SignUpBloc, SignUpState>(
              builder: (context, state) {
                var error = '';
                if(state is SignUpFormValidationError){
                  error = state.confirmPassword;
                }
                return EditText(
                  hint: AppStrings.confirmPassword,
                  controller: confPasswordCtrl,
                  isPassword: true,
                  margin: const EdgeInsets.only(top: AppFonts.s20),
                  error: error,
                );
              },
            ),
             AppButton(
               onTap: ()=> context.read<SignUpBloc>().add(SignupRegisterEvent(
                   email: emailCtrl.text,
                   password: passwordCtrl.text,
                   confirmPassword: confPasswordCtrl.text
               )),
              margin: const EdgeInsets.symmetric(vertical: AppFonts.s40),
              label: AppStrings.continuee,
              labelStyle: TextStyles.medium14White,
            ),
            Row(
              children: [
                const TextView(text: AppStrings.haveAnAccount,
                  textStyle: TextStyles.medium14Black,),
                TextView(
                  onTap: context.pop,
                  text: AppStrings.login,
                  textStyle: TextStyles.semiBold14Primary,)
              ],
            ),
          ],
        );
      },
    );
  }
}
