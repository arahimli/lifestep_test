import 'package:lifestep/features/tools/config/endpoint_config.dart';
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
        data!.add(DonationHistoryModel.fromJson(v));
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
        ? DonatableModel.fromJson(json['donatable'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['user_image'] = userImage;
    data['full_name'] = fullName;
    data['date'] = date;
    data['steps'] = steps;
    data['amount'] = amount;
    data['type'] = type;
    // if (donatable != null) {
    //   data['donatable'] = donatable!.toJson();
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
    image = json['image'] != null && json['image'] != '' ? sprintf( EndpointConfig.imageUrl , [json['image']]) : null;
    totalSteps = json['total_steps'];
    amount = json['amount'] != null ? double.parse(json['amount'].toString()) : 0;
    status = json['status'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    requiredSteps = json['required_steps'];
    presentSteps = json['present_steps'];
    sponsorImage = json['sponsor_image'] != null ? sprintf( EndpointConfig.imageUrl , [json['sponsor_image']]) : null;
    sponsorName = json['sponsor_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['total_steps'] = totalSteps;
    data['amount'] = amount;
    data['status'] = status;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['required_steps'] = requiredSteps;
    data['present_steps'] = presentSteps;
    data['sponsor_image'] = sponsorImage;
    data['sponsor_name'] = sponsorName;
    return data;
  }
}

