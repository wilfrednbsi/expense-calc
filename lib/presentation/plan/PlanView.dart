import 'package:flutter/material.dart';

import '../../components/constants/AppStrings.dart';
import '../../components/constants/TextStyles.dart';
import '../../components/widgets/AppBar2.dart';

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
    );
  }
}
