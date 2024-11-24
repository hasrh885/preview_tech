// To parse this JSON data, do
//
//     final readModel = readModelFromJson(jsonString);

import 'dart:convert';

List<ReadModel> readModelFromJson(String str) => List<ReadModel>.from(json.decode(str).map((x) => ReadModel.fromJson(x)));

String readModelToJson(List<ReadModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReadModel {
  List<dynamic>? list;
  List<dynamic>? inputControllers;
  List<dynamic>? total;
  int? totalSum;
  String? dateTime;

  ReadModel({
    this.list,
    this.inputControllers,
    this.total,
    this.totalSum,
    this.dateTime,
  });

  factory ReadModel.fromJson(Map<String, dynamic> json) => ReadModel(
    list: json["list"] == null ? [] : List<dynamic>.from(json["list"]!.map((x) => x)),
    inputControllers: json["inputControllers"] == null ? [] : List<dynamic>.from(json["inputControllers"]!.map((x) => x)),
    total: json["total"] == null ? [] : List<dynamic>.from(json["total"]!.map((x) => x)),
    totalSum: json["totalSum"],
    dateTime: json["date_time"],
  );

  Map<String, dynamic> toJson() => {
    "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x)),
    "inputControllers": inputControllers == null ? [] : List<dynamic>.from(inputControllers!.map((x) => x)),
    "total": total == null ? [] : List<dynamic>.from(total!.map((x) => x)),
    "totalSum": totalSum,
    "date_time": dateTime,
  };
}
