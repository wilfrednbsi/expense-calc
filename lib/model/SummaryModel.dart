// To parse this JSON data, do
//
//     final summaryModel = summaryModelFromJson(jsonString);

import 'dart:convert';

SummaryModel summaryModelFromJson(String str) => SummaryModel.fromJson(json.decode(str));

String summaryModelToJson(SummaryModel data) => json.encode(data.toJson());

class SummaryModel {
  num? available;
  num? expenses;
  num? savings;

  SummaryModel({
    this.available,
    this.expenses,
    this.savings,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) => SummaryModel(
    available: json["available"],
    expenses: json["expenses"],
    savings: json["savings"],
  );

  Map<String, dynamic> toJson() => {
    "available": available,
    "expenses": expenses,
    "savings": savings,
  };
}
