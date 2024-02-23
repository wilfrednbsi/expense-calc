// To parse this JSON data, do
//
//     final imageDataModel = imageDataModelFromJson(jsonString);

import 'dart:convert';
import '../components/constants/constants.dart';

ImageDataModel imageDataModelFromJson(String str) => ImageDataModel.fromJson(json.decode(str));

String imageDataModelToJson(ImageDataModel data) => json.encode(data.toJson());

class ImageDataModel {
  String? imageDataModelAssert;
  String? network;
  String? file;
  ImageType type;

  ImageDataModel({
    this.imageDataModelAssert,
    this.network,
    this.file,
    this.type = ImageType.asset
  });

  factory ImageDataModel.fromJson(Map<String, dynamic> json) => ImageDataModel(
    imageDataModelAssert: json["assert"],
    network: json["network"],
    file: json["file"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "assert": imageDataModelAssert,
    "network": network,
    "file": file,
    "type": type,
  };
}
