import 'package:lifestep/config/endpoints.dart';
import 'package:sprintf/sprintf.dart';

class DonationHistoryListResponse {
  bool? status;
  List<DonationHistoryModel>? data;
  String? message;

  DonationHistoryListResponse({this.status, this.data, this.message});

  DonationHistoryListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <DonationHistoryModel>[];
      json['data'].forEach((v) {
        data!.add(new DonationHistoryModel.fromJson(v));
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

class DonationHistoryModel {
  int? id;
  String? userImage;
  String? fullName;
  String? date;
  int? steps;
  double? amount;
  String? type;
  DonatableModel? donatable;

  DonationHistoryModel(
      {this.id,
        this.userImage,
        this.fullName,
        this.date,
        this.steps,
        this.amount,
        this.type,
        this.donatable
      });

  DonationHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userImage = json['user_image'];
    fullName = json['full_name'];
    date = json['date'];
    steps = json['steps'];
    amount = json['amount'] != null ? double.parse(json['amount'].toString()) : 0;
    type = json['type'];
    donatable = json['donatable'] != null
        ? new DonatableModel.fromJson(json['donatable'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_image'] = this.userImage;
    data['full_name'] = this.fullName;
    data['date'] = this.date;
    data['steps'] = this.steps;
    data['amount'] = this.amount;
    data['type'] = this.type;
    // if (this.donatable != null) {
    //   data['donatable'] = this.donatable!.toJson();
    // }
    return data;
  }
}

class DonatableModel {
  int? id;
  String? name;
  String? description;
  String? image;
  int? totalSteps;
  double? amount;
  int? status;
  String? startDate;
  String? endDate;
  int? requiredSteps;
  int? presentSteps;
  String? sponsorImage;
  String? sponsorName;

  DonatableModel(
      {this.id,
        this.name,
        this.description,
        this.image,
        this.totalSteps,
        this.amount,
        this.status,
        this.startDate,
        this.endDate,
        this.requiredSteps,
        this.presentSteps,
        this.sponsorImage,
        this.sponsorName});

  DonatableModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'] != null && json['image'] != '' ? sprintf( IMAGE_URL , [json['image']]) : null;
    totalSteps = json['total_steps'];
    amount = json['amount'] != null ? double.parse(json['amount'].toString()) : 0;
    status = json['status'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    requiredSteps = json['required_steps'];
    presentSteps = json['present_steps'];
    sponsorImage = json['sponsor_image'];
    sponsorName = json['sponsor_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['total_steps'] = this.totalSteps;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['required_steps'] = this.requiredSteps;
    data['present_steps'] = this.presentSteps;
    data['sponsor_image'] = this.sponsorImage;
    data['sponsor_name'] = this.sponsorName;
    return data;
  }
}

