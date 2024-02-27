import 'package:expense_calc/components/constants/AppFonts.dart';
import 'package:expense_calc/components/constants/AppStrings.dart';
import 'package:expense_calc/components/coreComponents/AppButton.dart';
import 'package:expense_calc/components/coreComponents/EditText.dart';
import 'package:expense_calc/components/coreComponents/TextView.dart';
import 'package:expense_calc/components/widgets/AppBar2.dart';
import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/constants/TextStyles.dart';
import '../../viewController/transaction/transaction_bloc.dart';

class CreateTransaction extends StatefulWidget {
  const CreateTransaction({super.key});

  @override
  State<CreateTransaction> createState() => _CreateTransactionState();
}

class _CreateTransactionState extends State<CreateTransaction> {
  late TransactionBloc bloc;
  final amountCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc = context.read<TransactionBloc>();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBar2(
              title: AppStrings.createTransaction,
              titleStyle: TextStyles.bold22Black,
              onLeadTap: context.pop,
            ),
            _mainForm()
          ],
        ),
      ),
    );
  }

  Widget _mainForm() {
    return Expanded(
        child: SingleChildScrollView(
      padding: const EdgeInsets.all(AppFonts.s16),
      child: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is NewTransactionLoadingState) {
            context.load;
          } else if (state is NewTransactionFailureState) {
            context.stopLoader;
            context.openFailureDialog(state.error);
          } else if (state is NewTransactionSuccessState) {
            context.stopLoader;
            context.pop();
          } else if (state is TransactionCreateFormError) {
            context.stopLoader;
          }
        },
        builder: (context, state) {
          final error = state is TransactionCreateFormError ? state : null;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _editTextHeader(AppStrings.availableBalance),
              EditText(
                controller: TextEditingController(text: '${bloc.availableAmount}'),
                readOnly: true,
                margin: const EdgeInsets.only(bottom: AppFonts.s20),
              ),
              _editTextHeader(AppStrings.amount),
              EditText(
                controller: amountCtrl,
                margin: const EdgeInsets.only(bottom: AppFonts.s20),
                error: error?.amount ?? '',
                inputType: TextInputType.number,
                format: [
                  // LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
              _editTextHeader(AppStrings.shortDesc),
              EditText(
                controller: descCtrl,
                margin: const EdgeInsets.only(bottom: AppFonts.s40),
                error: error?.shortDesc ?? '',

              ),
              AppButton(
                onTap: ()=> bloc.add(NewTransactionEvent(amount: amountCtrl.text, desc: descCtrl.text)),
                label: AppStrings.submit,
              )
            ],
          );
        },
      ),
    ));
  }

  Widget _editTextHeader(String title) => TextView(
        text: title,
        textStyle: TextStyles.regular12Black,
      );
}
