import 'package:lifestep/features/tools/config/endpoint_config.dart';
import 'package:sprintf/sprintf.dart';

class CharityListResponse {
  bool? status;
  List<CharityModel>? data;
  String? message;

  CharityListResponse({this.status, this.data, this.message});

  CharityListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <CharityModel>[];
      json['data'].forEach((v) {
        data!.add(CharityModel.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class CharityModel {
  int? id;
  String? name;
  String? description;
  String? startDate;
  String? endDate;
  String? image;
  int requiredSteps = 0;
  int presentSteps = 0;
  double? amount;
  int? status;
  String? sponsorImage;
  String? sponsorName;

  CharityModel(
      {
        this.id,
        this.name,
        this.description,
        this.startDate,
        this.endDate,
        this.image,
        this.requiredSteps = 0,
        this.presentSteps = 0,
        this.amount,
        this.status,
        this.sponsorImage,
        this.sponsorName});

  CharityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    image = json['image'] != null ? sprintf( EndpointConfig.imageUrl , [json['image']]) : null;
    requiredSteps = json['required_steps'] ?? 0;
    presentSteps = json['present_steps'] ?? 0;
    amount = json['amount'] != null ? double.parse(json['amount'].toString()) : 0;
    status = json['status'];
    sponsorImage = json['sponsor_image'] != null ? sprintf( EndpointConfig.imageUrl , [json['sponsor_image']]) : null;
    sponsorName = json['sponsor_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['image'] = image;
    data['required_steps'] = requiredSteps;
    data['present_steps'] = presentSteps;
    data['amount'] = amount;
    data['status'] = status;
    data['sponsor_image'] = sponsorImage;
    data['sponsor_name'] = sponsorName;
    return data;
  }
  bool isCompleted() => presentSteps >= requiredSteps;
}
