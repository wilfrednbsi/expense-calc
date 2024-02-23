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
  int? amount;

  TransactionModel({
    this.timeStamp,
    this.type,
    this.amount,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
    timeStamp: json["timeStamp"],
    type: json["type"],
    amount: json["amount"],
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
    }else if(getType == TransactionType.rent){
      result = '-';
    }
    return result;
  }



  Map<String, dynamic> toJson() => {
    "timeStamp": timeStamp,
    "type": type,
    "amount": amount,
  };
}
