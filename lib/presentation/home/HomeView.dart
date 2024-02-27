import 'package:expense_calc/components/constants/AppColors.dart';
import 'package:expense_calc/components/constants/AppFonts.dart';
import 'package:expense_calc/components/constants/AppIcons.dart';
import 'package:expense_calc/components/constants/AppStrings.dart';
import 'package:expense_calc/components/constants/TextStyles.dart';
import 'package:expense_calc/components/constants/constants.dart';
import 'package:expense_calc/components/coreComponents/AppButton.dart';
import 'package:expense_calc/components/coreComponents/ImageView.dart';
import 'package:expense_calc/components/coreComponents/TextView.dart';
import 'package:expense_calc/components/widgets/AppBar2.dart';
import 'package:expense_calc/model/TransactionModel.dart';
import 'package:expense_calc/utils/AppExtensions.dart';
import 'package:expense_calc/utils/DateTimeUtils.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
    return const Expanded(child: SingleChildScrollView(
      padding: EdgeInsets.all(AppFonts.s16),
      child: Column(
        children: [
          _CardView(
            totalAmount: 1452896,
          ),
          _CategoryView(),
          _TransactionList()
        ],
      ),
    ));
  }
}

class _CategoryView extends StatelessWidget {
  const _CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextView(text: AppStrings.categories,textStyle: TextStyles.regular14Black,
          margin: EdgeInsets.only(top: AppFonts.s20,bottom: AppFonts.s10),
        ),
        Row(children: [
          Expanded(child: _card(value: '1452639',title: AppStrings.need)),
          const SizedBox(width: AppFonts.s16,),
          Expanded(child: _card(value: '1452639',title: AppStrings.expenses)),
        ],),
        const SizedBox(height: AppFonts.s16,),
        _card(value: '1452639',title: AppStrings.savings),
      ],
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
  final num totalAmount;
  const _CardView({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
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
                  onClick: (){},
                  icon: AppIcons.add, value: AppStrings.addFund)
            ],
          ),
          TextView(text: '${AppStrings.rupeeUnicode} $totalAmount', textStyle: TextStyles.semiBold30White,
            margin: const EdgeInsets.only(top: AppFonts.s7, bottom: AppFonts.s30
            ),
          ),

          button(icon: AppIcons.balance, value: '$totalAmount')

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

class _TransactionList extends StatelessWidget {
  const _TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextView(text: AppStrings.allTransactions,textStyle: TextStyles.regular14Black,
          margin: EdgeInsets.only(top: AppFonts.s20,bottom: AppFonts.s10),
        ),

        ListView.separated(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => _card(data: TransactionModel(
                amount: 142563,
                timeStamp: DateTimeUtils.getCurrentTimeStamp,
                type: TransactionType.rent.name
            )),
            separatorBuilder: (context, index) => const SizedBox(height: AppFonts.s16,),
            itemCount: 5
        )
      ],
    );
  }


  Widget _card({required TransactionModel data}){
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: AppFonts.s10, vertical: AppFonts.s20),
      decoration: BoxDecoration(
          color: AppColors.grey40.withOpacity(0.2),
          borderRadius: BorderRadius.circular(AppFonts.s10)
      ),
      child: Row(
        children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextView(text: data.getType.getName,textStyle: TextStyles.regular14Black,),
              TextView(text: data.timeStamp!.ddMMMyyyy_hhmma,textStyle: TextStyles.regular10Black,)
            ],
          )),
          TextView(text: '${data.transactionSign} ${AppStrings.rupeeUnicode} ${data.amount}',textStyle: TextStyles.medium16Black,)
        ],
      ),
    );
  }
}