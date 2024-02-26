import 'package:expense_calc/components/constants/constants.dart';
import 'package:expense_calc/presentation/home/HomeView.dart';
import 'package:expense_calc/presentation/plan/PlanView.dart';
import 'package:expense_calc/presentation/profile/ProfileTabView.dart';
import 'package:expense_calc/presentation/wallet/WalletView.dart';
import 'package:expense_calc/viewController/bottomTabs/bottom_tabs_bloc.dart';
import 'package:expense_calc/viewController/profile/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/constants/AppColors.dart';
import '../../components/constants/AppFonts.dart';
import '../../components/coreComponents/ImageView.dart';

class BottomTabs extends StatefulWidget {
  const BottomTabs({super.key});

  @override
  State<BottomTabs> createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {

  final List<Widget> tabs = [const HomeView(),
    const WalletView(),
    const PlanView(),
    const ProfileTabView()];


  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(FetchProfileEvent());
    _changeTab(0);
  }

  void _changeTab(int index) => context.read<BottomTabsBloc>().add(ChangeTab(index: index));

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BottomTabsBloc, BottomTabsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: tabs[state.index],
          ),
          bottomNavigationBar: BottomNavBar(
            activeIndex: state.index,
            onSelect: _changeTab,
            tabs: bottomTabsList,
          ),
        );
      },
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final List<String> tabs;
  final Function(int) onSelect;
  final int activeIndex;

  const BottomNavBar(
      {super.key,
      required this.tabs,
      required this.onSelect,
      required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: AppFonts.s16,
          bottom: AppFonts.s10 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
          color: AppColors.primaryColor,
          boxShadow: [
            BoxShadow(color: AppColors.primaryColor, blurRadius: 15)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: tabs
            .asMap()
            .map((index, value) => MapEntry(
                index,
                BottomTabsItem(
                    icon: value ?? '',
                    status: activeIndex == index,
                    onTap: () {
                      onSelect(index);
                      // bookingCtrl.swapBookingFlag.value = false;
                    })))
            .values
            .toList(),
      ),
    );
  }
}

class BottomTabsItem extends StatelessWidget {
  final String icon;
  final bool status;
  final Function()? onTap;

  const BottomTabsItem(
      {super.key, required this.icon, required this.status, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ImageView(
      onTap: onTap,
      url: icon,
      size: AppFonts.s22,
      tintColor: status ? AppColors.white : AppColors.grey20,
      margin: const EdgeInsets.only(bottom: 3),
    );
  }
}
