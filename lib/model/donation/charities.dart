import 'package:lifestep/config/endpoints.dart';
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
        data!.add(new CharityModel.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
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
      {this.id,
        this.name,
        this.description,
        this.startDate,
        this.endDate,
        this.image,
        this.requiredSteps: 0,
        this.presentSteps: 0,
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
    image = json['image'] != null ? sprintf( IMAGE_URL , [json['image']]) : null;
    requiredSteps = json['required_steps'] ?? 0;
    presentSteps = json['present_steps'] ?? 0;
    amount = json['amount'] != null ? double.parse(json['amount'].toString()) : 0;
    status = json['status'];
    sponsorImage = json['sponsor_image'] != null ? sprintf( IMAGE_URL , [json['sponsor_image']]) : null;
    sponsorName = json['sponsor_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['image'] = this.image;
    data['required_steps'] = this.requiredSteps;
    data['present_steps'] = this.presentSteps;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['sponsor_image'] = this.sponsorImage;
    data['sponsor_name'] = this.sponsorName;
    return data;
  }
}
