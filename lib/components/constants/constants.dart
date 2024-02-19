import 'package:flutter/material.dart';

enum GenderEnum {male,female}
enum WeightEnum {kg,lbs}
enum HeightEnum {inch,cm}

enum BmiRemarksEnum {Underweight,Normal,Overweight,Obese}

List bmiStatusColors = [Colors.blueAccent,Colors.greenAccent, Colors.orangeAccent, Colors.redAccent];

class Height{
  static final List<int> feet = List.generate(9, (index) => index);
  static final List<int> inches = List.generate(12, (index) => index);
  static final List<int> cms = List.generate(211, (index) => index + 35);
}

class Weight{
  static final List<int> kg = List.generate(148, (index) => index + 3);
  static final List<int> lbs = List.generate(325, (index) => index + 6);
}

class Age{
  static final List<int> age = List.generate(120, (index) => index + 1);
}