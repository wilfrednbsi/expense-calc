// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  String? uid;
  String? name;
  String? email;
  String? phone;
  String? image;

  ProfileModel({
    this.uid,
    this.name,
    this.email,
    this.phone,
    this.image,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    uid: json["uid"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "email": email,
    "phone": phone,
    "image": image,
  };
}
