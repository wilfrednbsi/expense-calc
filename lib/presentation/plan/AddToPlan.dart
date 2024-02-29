import 'package:expense_calc/components/constants/AppColors.dart';
import 'package:expense_calc/components/constants/AppFonts.dart';
import 'package:expense_calc/components/coreComponents/AppButton.dart';
import 'package:expense_calc/components/coreComponents/EditText.dart';
import 'package:expense_calc/components/coreComponents/TextView.dart';
import 'package:expense_calc/model/PlanModel.dart';
import 'package:expense_calc/presentation/wallet/CreateTransaction.dart';
import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/constants/AppStrings.dart';
import '../../components/constants/TextStyles.dart';
import '../../components/widgets/AppBar2.dart';
import '../../viewController/transaction/transaction_bloc.dart';

class AddToPlan extends StatefulWidget {
  const AddToPlan({super.key});

  @override
  State<AddToPlan> createState() => _AddToPlanState();
}

class _AddToPlanState extends State<AddToPlan> {
  late TransactionBloc bloc;

  final amountCtrl = TextEditingController();
  final planCtrl = TextEditingController();
  final targetCtrl = TextEditingController();
  final collectedCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc = context.read<TransactionBloc>();
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (value)=> bloc.resetChoosePlan(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar2(
                title: AppStrings.addToPlan,
                titleStyle: TextStyles.bold22Black,
                onLeadTap: context.pop,
              ),
              _form()
            ],
          ),
        ),
      ),
    );
  }

  Widget _form() {
    return Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppFonts.s16),
          child: BlocConsumer<TransactionBloc, TransactionState>(
            listener: (context, state) {
              if(state is PlanAmountSuccessState){
                context.stopLoader;
                context.pop();
              }else if(state is PlanAmountFormValidationState){
                context.stopLoader;
              }else if(state is PlanAmountFailureState){
                context.stopLoader;
                context.openFailureDialog(state.error);
              }else if(state is PlanAmountLoadingState){
                context.load;
              }else if(state is PlanAmountChoosePlanState){

                targetCtrl.text = '${bloc.choosePlan?.target ?? 0}';
                collectedCtrl.text = '${bloc.choosePlan?.collected ?? 0}';
              }
            },
            builder: (context, state) {
              final error = state is PlanAmountFormValidationState ? state : null;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  editTextHeader(AppStrings.availableBalance),
                  EditText(
                    controller: TextEditingController(text: '${bloc.availableAmount}'),
                    readOnly: true,
                    margin: const EdgeInsets.only(bottom: AppFonts.s20),
                  ),
                  editTextHeader(AppStrings.chooseYourPlan),
                  DropView(
                      list: bloc.planList,
                    selectedIndex: bloc.choosePlanIndex,
                    error: error?.plan,
                    onSelect: (value)=> bloc.add(ChoosePlanEvent(plan: value)),
                  ),
                  editTextHeader(AppStrings.target),
                  EditText(
                    controller: targetCtrl,
                    readOnly: true,
                    margin: const EdgeInsets.only(bottom: AppFonts.s20),
                  ),
                  editTextHeader(AppStrings.collected),
                  EditText(
                    controller: collectedCtrl,
                    readOnly: true,
                    margin: const EdgeInsets.only(bottom: AppFonts.s20),
                  ),
                  editTextHeader(AppStrings.addAmount),
                  EditText(
                    controller: amountCtrl,
                    readOnly: bloc.choosePlan == null,
                    margin: const EdgeInsets.only(bottom: AppFonts.s40),
                    error: bloc.choosePlan != null ? error?.amount ?? '' : '',
                  ),
                  AppButton(
                    onTap: () => bloc.add(AddAmountToPlanEvent(amount: amountCtrl.text,)),
                    label: AppStrings.submit,
                  )
                ],
              );
            },
          ),
        ));
  }
}

class DropView extends StatelessWidget {
  final  List<PlanModel> list;
  final int? selectedIndex;
  final String? error;
  final Function(PlanModel) onSelect;
  const DropView({super.key, required this.list, this.selectedIndex,  this.error, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppFonts.s20),
      child: DropdownButtonFormField<PlanModel>(
        hint: const TextView(text: AppStrings.chooseYourPlan,textStyle: TextStyles.regularTextHint,),
        dropdownColor: AppColors.white,
        value: selectedIndex != null ? list[selectedIndex!] : null,
        items: list.map((PlanModel value) {
          return DropdownMenuItem<PlanModel>(
            onTap: ()=>onSelect(value),
            value: value,
            child: Text(value.plan ?? '')
          );
        }).toList(),onChanged: (value){
      },
        decoration: InputDecoration(
          errorText: error != null ? error!.isNotEmpty ? error : null : null
        ),
      ),
    );
  }
}