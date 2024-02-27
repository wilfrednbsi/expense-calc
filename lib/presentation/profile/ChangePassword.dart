import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:expense_calc/viewController/changePassword/change_password_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/constants/AppFonts.dart';
import '../../components/constants/AppStrings.dart';
import '../../components/constants/TextStyles.dart';
import '../../components/coreComponents/AppButton.dart';
import '../../components/coreComponents/EditText.dart';
import '../../components/widgets/AppBar2.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final oldCtrl = TextEditingController();
  final newCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  late ChangePasswordBloc passwordBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      passwordBloc = _getPasswordBloc(context);
      passwordBloc.add(const ClearFormErrorEvent());
    });

  }

  ChangePasswordBloc _getPasswordBloc(BuildContext context) {
    return context.read<ChangePasswordBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBar2(
              title: AppStrings.changePassword,
              titleStyle: TextStyles.bold22Black,
              onLeadTap: context.pop,
            ),
            mainForm(context: context)
          ],
        ),
      ),
    );
    ;
  }

  Widget mainForm({required BuildContext context}) {
    return Expanded(
        child: SingleChildScrollView(
      padding: const EdgeInsets.all(AppFonts.s16),
      child: Column(
        children: [
          BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
            listener: (context, state) {
              if (state is ChangePasswordLoadingState) {
                context.load;
              } else if (state is ChangePasswordSuccessState) {
                context.stopLoader;
                context.pop();
              } else if (state is ChangePasswordFailureState) {
                context.stopLoader;
                context.openFailureDialog(state.message);
              } else if (state is ChangePasswordFormValidationErrorState) {
                context.stopLoader;
              }
            },
            builder: (context, state) {
              final formError = state is ChangePasswordFormValidationErrorState
                  ? state
                  : null;
              return Column(
                children: [
                  EditText(
                    hint: AppStrings.enterYourOldPassword,
                    controller: oldCtrl,
                    isPassword: true,
                    error: formError?.oldPassword,
                  ),
                  EditText(
                    hint: AppStrings.enterNewPassword,
                    controller: newCtrl,
                    margin: const EdgeInsets.symmetric(vertical: AppFonts.s20),
                    isPassword: true,
                    error: formError?.newPassword,
                  ),
                  EditText(
                    hint: AppStrings.confirmPassword,
                    controller: confirmCtrl,
                    isPassword: true,
                    error: formError?.confirmPassword,
                  ),
                ],
              );
            },
          ),
          AppButton(
            onTap: () => passwordBloc.add(OnChangeEvent(
                newPassword: newCtrl.text,
                oldPassword: oldCtrl.text,
                confirmPassword: confirmCtrl.text)),
            label: AppStrings.change,
            margin: const EdgeInsets.only(top: AppFonts.s40),
          )
        ],
      ),
    ));
  }
}
