import 'package:expense_calc/components/constants/AppColors.dart';
import 'package:expense_calc/components/constants/AppFonts.dart';
import 'package:expense_calc/components/constants/AppIcons.dart';
import 'package:expense_calc/components/constants/AppStrings.dart';
import 'package:expense_calc/components/constants/TextStyles.dart';
import 'package:expense_calc/components/coreComponents/AppButton.dart';
import 'package:expense_calc/components/coreComponents/ImageView.dart';
import 'package:expense_calc/components/coreComponents/TextView.dart';
import 'package:expense_calc/components/widgets/AppBar2.dart';
import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../viewController/transaction/transaction_bloc.dart';
import '../wallet/WalletView.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late TransactionBloc tranBloc;

  @override
  void initState() {
    super.initState();
    tranBloc = context.read<TransactionBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        const AppBar2(
          title: AppStrings.appName,
          titleStyle: TextStyles.bold22Black,
          isLeadVisible: false,
        ),
        mainView(),
      ],
    );
  }

  Widget mainView(){
    return  Expanded(child: SingleChildScrollView(
      padding: const EdgeInsets.all(AppFonts.s16),
      child: BlocConsumer<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if(state is TransactionLoadingState){
            context.load;
          }else if(state is TransactionFailureState){
            context.stopLoader;
            context.openFailureDialog(state.error);
          }else if(state is TransactionSuccessState){
            context.stopLoader;
          }else if(state is TransactionAddFundFormError){
            context.stopLoader;
          }else if (state is TransactionCloseBSheetState){
            context.pop();
          }
        },
        builder: (context, state) {
          return  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CardView(),
              const _CategoryView(),
              TransactionHistoryList(list: tranBloc.getLastTransactions, title: AppStrings.lastTransactions,)
            ],
          );
        },
      )
    ));
  }
}

class _CategoryView extends StatelessWidget {
  const _CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    TransactionBloc transactionBloc = context.read<TransactionBloc>();
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextView(
              text: AppStrings.categories,
              textStyle: TextStyles.regular14Black,
              margin: EdgeInsets.only(top: AppFonts.s20, bottom: AppFonts.s10),
            ),
            Row(
              children: [
                Expanded(
                    child: _card(
                        value: '${transactionBloc.expenses}',
                        title: AppStrings.expenses)),
                const SizedBox(
                  width: AppFonts.s16,
                ),
                Expanded(
                    child: _card(
                        value: '${transactionBloc.savings}', title: AppStrings.savings)),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _card({required String title, required String value}){
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: AppFonts.s10, vertical: AppFonts.s30),
      decoration: BoxDecoration(
          color: AppColors.grey40.withOpacity(0.2),
          borderRadius: BorderRadius.circular(AppFonts.s10)
      ),
      child:  Column(
        children: [
          TextView(text: title,textStyle: TextStyles.medium16Primary,),
          TextView(text: '${AppStrings.rupeeUnicode} $value',textStyle: TextStyles.medium20Black, margin: const EdgeInsets.only(top: AppFonts.s7),),
        ],
      ),
    );
  }
}

class _CardView extends StatelessWidget {
  const _CardView({super.key,});

  @override
  Widget build(BuildContext context) {
    TransactionBloc transactionBloc = context.read<TransactionBloc>();
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.all(AppFonts.s10),
      decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(AppFonts.s16)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(child: TextView(text: AppStrings.totalBalance, textStyle: TextStyles.medium16White,)),
              button(
                  onClick: () => addFundBSheet(context),
                  icon: AppIcons.add, value: AppStrings.addFund)
            ],
          ),

          BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
              return TextView(
                text:
                '${AppStrings.rupeeUnicode} ${transactionBloc.availableAmount}',
                textStyle: TextStyles.semiBold30White,
                margin: const EdgeInsets.only(
                    top: AppFonts.s7, bottom: AppFonts.s30),
              );
            },
          )
        ],
      ),
    );
  }


  Widget button({required String icon, required String value,  Function()? onClick}){
    return Row(
      children: [
        AppButton(
          onTap: onClick,
          buttonColor: AppColors.grey10.withOpacity(0.15),
          fillWidth: false,
          padding: const EdgeInsets.symmetric(horizontal: AppFonts.s16, vertical: AppFonts.s7),
          radius: AppFonts.s24,
          child:  Row(
            children: [
              ImageView(url: icon, size: AppFonts.s14,tintColor: AppColors.white,margin: const EdgeInsets.only(right: AppFonts.s10),),
              TextView(text: value, textStyle: TextStyles.medium12White,),
            ],
          ),
        ),
      ],
    );
  }
}