// To parse this JSON data, do
//
//     final planModel = planModelFromJson(jsonString);

import 'dart:convert';

PlanModel planModelFromJson(String str) => PlanModel.fromJson(json.decode(str));

String planModelToJson(PlanModel data) => json.encode(data.toJson());

class PlanModel {
String? plan;
int? target;
int? collected;
String? id;

PlanModel({
this.plan,
this.target,
this.collected,
this.id,
});

factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
plan: json["plan"],
target: json["target"],
collected: json["collected"],
id: json["id"],
);

Map<String, dynamic> toJson() => {
"plan": plan,
"target": target,
"collected": collected,
"id": id,
};
}
