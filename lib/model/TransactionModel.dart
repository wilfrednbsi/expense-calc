// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

import 'package:expense_calc/components/constants/constants.dart';

TransactionModel transactionModelFromJson(String str) => TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) => json.encode(data.toJson());

class TransactionModel {
  int? timeStamp;
  String? type;
  num? amount;
  String? desc;
  String? uid;

  TransactionModel({
    this.timeStamp,
    this.type,
    this.amount,
    this.desc,
    this.uid,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
    timeStamp: json["timeStamp"],
    type: json["type"],
    amount: json["amount"],
    desc: json["desc"],
    uid: json["uid"],
  );

  TransactionType get getType {
    TransactionType result = TransactionType.rent;
    if(type == TransactionType.rent.name){
      result = TransactionType.rent;
    }else if(type == TransactionType.fundAdd.name){
      result = TransactionType.fundAdd;
    }
    return result;
  }

  String get transactionSign {
    String result = '';
    if(getType == TransactionType.fundAdd){
      result = '+';
    }else if(getType == TransactionType.rent || getType == TransactionType.expenses){
      result = '-';
    }
    return result;
  }



  Map<String, dynamic> toJson() => {
    "timeStamp": timeStamp,
    "type": type,
    "amount": amount,
    "desc": desc,
    "uid": uid,
  };
}
