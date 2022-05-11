// To parse this JSON data, do
//
//     final modelVersion = modelVersionFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

// class ModelVersion {
//   ModelVersion({
//     @required this.the0,
//     @required this.versionCode,
//   });
//
//   final String the0;
//   final String versionCode;
//
//   factory ModelVersion.fromJson(String str) => ModelVersion.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory ModelVersion.fromMap(Map<String, dynamic> json) => ModelVersion(
//     the0: json["0"],
//     versionCode: json["versionCode"],
//   );
//
//   Map<String, dynamic> toMap() => {
//     "0": the0,
//     "versionCode": versionCode,
//   };
// }
class ModelVersion {
  String s0;
  String versionCode;

  ModelVersion({this.s0, this.versionCode});

  ModelVersion.fromJson(Map<String, dynamic> json) {
    s0 = json['0'];
    versionCode = json['versionCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['0'] = this.s0;
    data['versionCode'] = this.versionCode;
    return data;
  }
}
