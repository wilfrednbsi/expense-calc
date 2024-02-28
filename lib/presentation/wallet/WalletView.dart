import 'package:expense_calc/components/constants/AppFonts.dart';
import 'package:expense_calc/components/constants/AppStrings.dart';
import 'package:expense_calc/components/coreComponents/AppButton.dart';
import 'package:expense_calc/components/coreComponents/EditText.dart';
import 'package:expense_calc/components/coreComponents/TextView.dart';
import 'package:expense_calc/components/widgets/AppBar2.dart';
import 'package:expense_calc/presentation/plan/AddToPlan.dart';
import 'package:expense_calc/presentation/wallet/CreateTransaction.dart';
import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:expense_calc/utils/DateTimeUtils.dart';
import 'package:expense_calc/viewController/bottomTabs/bottom_tabs_bloc.dart';
import 'package:expense_calc/viewController/transaction/transaction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/constants/AppColors.dart';
import '../../components/constants/TextStyles.dart';
import '../../model/TransactionModel.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  late TransactionBloc tranBloc;

  @override
  void initState() {
    super.initState();
    tranBloc = context.read<TransactionBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar2(
          title: AppStrings.wallet,
          titleStyle: TextStyles.bold22Black,
          isLeadVisible: false,
          tail: TextView(
            onTap: () => addFundBSheet(context),
            text: AppStrings.addFund,
            textStyle: TextStyles.medium16Primary,
          ),
        ),
        _mainView()
      ],
    );
  }

  Widget _mainView() {
    return Expanded(
        child: SingleChildScrollView(
      padding: const EdgeInsets.all(AppFonts.s16),
      child: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is TransactionLoadingState) {
            context.load;
          } else if (state is TransactionFailureState) {
            context.stopLoader;
            context.openFailureDialog(state.error);
          } else if (state is TransactionSuccessState) {
            context.stopLoader;
          } else if (state is TransactionAddFundFormError) {
            context.stopLoader;
          } else if (state is TransactionCloseBSheetState) {
            context.pop();
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _overView(),
              AppButton(
                onTap: () {
                  bSheetView(
                      context,
                      AppStrings.selectMethod,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppButton(
                            onTap: () => {
                              context.pop(),
                              context.pushNavigator(const CreateTransaction())
                            },
                            label: AppStrings.expenses,
                          ),
                           AppButton(
                             onTap: (){
                               context.pop();
                               if(tranBloc.planList.isNotEmpty){
                                 context.pushNavigator(const AddToPlan());
                               }else{
                                 context.read<BottomTabsBloc>().add(const ChangeTab(index: 2));
                               }
                             },
                            label: AppStrings.addToPlan,
                            margin: const EdgeInsets.only(
                                top: AppFonts.s16, bottom: AppFonts.s30),
                          ),
                        ],
                      ));
                },
                margin: const EdgeInsets.symmetric(vertical: AppFonts.s20),
                label: AppStrings.newTransaction,
              ),
              TransactionHistoryList(
                  title: AppStrings.allTransactions, list: tranBloc.tranList)
            ],
          );
        },
      ),
    ));
  }

  Widget _overView() {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: _cashTile(
                        AppStrings.availableBalance, tranBloc.availableAmount)),
              ],
            ),
            const SizedBox(
              height: AppFonts.s7,
            ),
            Row(
              children: [
                Expanded(
                    child: _cashTile(AppStrings.expenses, tranBloc.expenses)),
                Expanded(
                    child: _cashTile(AppStrings.savings, tranBloc.savings)),
              ],
            )
          ],
        );
      },
    );
  }

  Widget _cashTile(String title, value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextView(
          text: title,
          textStyle: TextStyles.medium12Black,
        ),
        TextView(
          text: '${AppStrings.rupeeUnicode} $value',
          textStyle: TextStyles.semiBold20Black,
        ),
      ],
    );
  }
}

void addFundBSheet(BuildContext context) {
  final fundCtrl = TextEditingController();
  bSheetView(
      context,
      AppStrings.addFund,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              final error = state is TransactionAddFundFormError ? state : null;
              return EditText(
                controller: fundCtrl,
                error: error?.error ?? '',
                inputType: TextInputType.number,
                format: [
                  // LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly
                ],
              );
            },
          ),
          AppButton(
            onTap: () => context
                .read<TransactionBloc>()
                .add(AddFundEvent(fund: fundCtrl.text)),
            label: AppStrings.add,
            margin:
                const EdgeInsets.only(top: AppFonts.s16, bottom: AppFonts.s30),
          ),
        ],
      ));
}

void bSheetView(BuildContext context, String title, Widget child) {
  context.openBottomSheet(Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppFonts.s16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextView(
          text: title,
          textStyle: TextStyles.regular10Black,
          margin: const EdgeInsets.only(bottom: AppFonts.s10),
        ),
        child
      ],
    ),
  ));
}

class TransactionHistoryList extends StatelessWidget {
  final String title;
  final List<TransactionModel> list;

  const TransactionHistoryList(
      {super.key, required this.list, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextView(
          text: title,
          textStyle: TextStyles.regular14Black,
          margin:
              const EdgeInsets.only(top: AppFonts.s20, bottom: AppFonts.s10),
        ),
        SizedBox(
          child: list.isNotEmpty
              ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => _card(data: list[index]),
                  itemCount: list.length)
              : const TextView(
                  margin: EdgeInsets.symmetric(vertical: AppFonts.s40),
                  text: AppStrings.noTransactionRecord,
                  textStyle: TextStyles.semiBold20Black,
                ),
        )
      ],
    );
  }

  Widget _card({required TransactionModel data}) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppFonts.s16),
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(
          horizontal: AppFonts.s10, vertical: AppFonts.s20),
      decoration: BoxDecoration(
          color: AppColors.grey40.withOpacity(0.2),
          borderRadius: BorderRadius.circular(AppFonts.s10)),
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextView(
                text: data.desc ?? '',
                textStyle: TextStyles.regular14Black,
              ),
              TextView(
                text: data.timeStamp?.ddMMMyyyy_hhmma ?? '',
                textStyle: TextStyles.regular10Black,
              )
            ],
          )),
          TextView(
            text:
                '${data.transactionSign} ${AppStrings.rupeeUnicode} ${data.amount}',
            textStyle: TextStyles.medium16Black,
          )
        ],
      ),
    );
  }
}
