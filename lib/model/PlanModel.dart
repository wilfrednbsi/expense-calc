// To parse this JSON data, do
//
//     final planModel = planModelFromJson(jsonString);

import 'dart:convert';

PlanModel planModelFromJson(String str) => PlanModel.fromJson(json.decode(str));

String planModelToJson(PlanModel data) => json.encode(data.toJson());

class PlanModel {
  String? plan;
  num? target;
  num? collected;
  String? uid;
  int? timeStamp;
  String? docId;

  PlanModel({
    this.plan,
    this.target,
    this.collected,
    this.uid,
    this.timeStamp,
    this.docId,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
        plan: json["plan"],
        target: json["target"],
        collected: json["collected"],
        uid: json["uid"],
        timeStamp: json["timeStamp"],
        docId: json["docId"],
      );

  Map<String, dynamic> toJson() => {
        "plan": plan,
        "target": target,
        "collected": collected,
        "uid": uid,
        "timeStamp": timeStamp,
      };

  Map<String, dynamic> toJsonUpdateAmount() => {
    "collected": collected,
  };

  Map<String, dynamic> toJsonWithKey() => {
    "plan": plan,
    "target": target,
    "collected": collected,
    "uid": uid,
    "timeStamp": timeStamp,
    "docId": docId,
  };
}
