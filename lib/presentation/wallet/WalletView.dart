import 'package:flutter/material.dart';

import '../../components/constants/AppStrings.dart';
import '../../components/constants/TextStyles.dart';
import '../../components/widgets/AppBar2.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppBar2(
          title: AppStrings.appName,
          titleStyle: TextStyles.bold22Black,
          isLeadVisible: false,
        ),
        Expanded(child: Column(
          children: [

          ],
        ))
      ],
    );;
  }
}
