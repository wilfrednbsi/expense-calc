import 'package:expense_calc/components/coreComponents/AppButton.dart';
import 'package:expense_calc/components/coreComponents/EditText.dart';
import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/constants/AppColors.dart';
import '../../components/constants/AppFonts.dart';
import '../../components/constants/AppStrings.dart';
import '../../components/constants/TextStyles.dart';
import '../../components/coreComponents/TextView.dart';
import '../../components/widgets/AppBar2.dart';
import '../../model/PlanModel.dart';
import '../../viewController/transaction/transaction_bloc.dart';
import '../wallet/WalletView.dart';

class PlanView extends StatefulWidget {
  const PlanView({super.key});

  @override
  State<PlanView> createState() => _PlanViewState();
}

class _PlanViewState extends State<PlanView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar2(
          title: AppStrings.plan,
          titleStyle: TextStyles.bold22Black,
          isLeadVisible: false,
          tail: TextView(
            onTap: _addNewPlan,
            text: AppStrings.addPlan,
            textStyle: TextStyles.medium16Primary,
          ),
        ),
        const Expanded(child: MyPlans()),
      ],
    );
  }

  void _addNewPlan() {
    final planCtrl = TextEditingController();
    final targetCtrl = TextEditingController();
    final initialCtrl = TextEditingController();
    final bloc = context.read<TransactionBloc>();
    bloc.resetAddPlan();
    bSheetView(context,
        AppStrings.createNewPlan,
        BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            final error = state is NewPlanFormValidationState ? state : null;
            return Column(
              children: [
                EditText(
                    hint: AppStrings.enterPlanName,
                    controller: planCtrl,
                  error: error?.plan ?? '',
                ),
                EditText(
                  hint: AppStrings.setTarget,
                  controller: targetCtrl,
                  inputType: TextInputType.number,
                  format: [FilteringTextInputFormatter.digitsOnly],
                  margin: const EdgeInsets.symmetric(vertical: AppFonts.s20),
                  onChange: (value)=> bloc.add(SetTargetPlanEvent(target: value)),
                  error: error?.target ?? '',
                ),
                EditText(
                    hint: AppStrings.initialAmount,
                    inputType: TextInputType.number,
                    readOnly: bloc.targetAddPlan == 0,
                    format: [FilteringTextInputFormatter.digitsOnly],
                    controller: initialCtrl,
                  error: error?.initial ?? '',
                ),
                AppButton(
                  onTap: () {
                    context.read<TransactionBloc>().add(AddPlanEvent(
                        plan: planCtrl.text.trim(),
                      target: targetCtrl.text.trim(),
                      amount: initialCtrl.text.trim()
                    ));
                  },
                  label: AppStrings.create,
                  margin: const EdgeInsets.symmetric(vertical: AppFonts.s40),
                )
              ],
            );
          },
        )
    );
  }
}

class MyPlans extends StatelessWidget {
  const MyPlans({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TransactionBloc>();
    return BlocConsumer<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is NewPlanLoadingState) {
          context.load;
        } else if (state is PlanSuccessState) {
          context.stopLoader;
        } else if (state is PlanFailureState) {
          context.stopLoader;
          context.openFailureDialog(state.error);
        } else if(state is NewPlanFormValidationState){
          context.stopLoader;
        } else if (state is NewPlanBSheetCloseState){
          context.pop();
        }
      },
      builder: (context, state) {
        return ListView.builder(
          itemBuilder: (context, index) =>
              _card(
                  data: bloc.planList[index]),
          itemCount: bloc.planList.length,
          shrinkWrap: true,
          padding: const EdgeInsets.all(AppFonts.s16),
        );
      },
    );
  }

  Widget _card({required PlanModel data}) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.grey40.withOpacity(0.2),
          borderRadius: BorderRadius.circular(AppFonts.s10)),
      margin: const EdgeInsets.only(bottom: AppFonts.s20),
      padding: const EdgeInsets.all(AppFonts.s14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextView(
            text: data.plan ?? '',
            textStyle: TextStyles.medium16Primary,
            margin: const EdgeInsets.only(bottom: AppFonts.s7),
          ),
          Row(
            children: [
              _amountTile(title: AppStrings.target, amount: data.target ?? 0),
              _amountTile(
                  title: AppStrings.collected, amount: data.collected ?? 0),
            ],
          )
        ],
      ),
    );
  }

  Widget _amountTile({required String title, required num amount}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextView(text: title, textStyle: TextStyles.regular10Black),
          TextView(
              text: '${AppStrings.rupeeUnicode} $amount',
              textStyle: TextStyles.medium16Black),
        ],
      ),
    );
  }
}
