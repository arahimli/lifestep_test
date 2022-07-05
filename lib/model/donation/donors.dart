
import 'package:lifestep/tools/constants/enum.dart';

class DonorListResponse {
  bool? status;
  DonorListModel? data;
  String? message;

  DonorListResponse({this.status, this.data, this.message});

  DonorListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new DonorListModel.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class DonorListModel {
  int? donateCount;
  List<DonorModel>? donates;

  DonorListModel({this.donateCount, this.donates});

  DonorListModel.fromJson(Map<String, dynamic> json) {
    donateCount = json['donate_count'];
    if (json['donates'] != null) {
      donates = <DonorModel>[];
      json['donates'].forEach((v) {
        donates!.add(new DonorModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['donate_count'] = this.donateCount;
    if (this.donates != null) {
      data['donates'] = this.donates!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class DonorModel {
  int? id;
  String? userImage;
  String? fullName;
  int? steps;
  GENDER_TYPE? genderType;
  double? amount;
  String? type;

  DonorModel(
      {this.id,
        this.userImage,
        this.fullName,
        this.steps,
        this.amount,
        this.genderType,
        this.type});

  DonorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userImage = json['user_image'];
    fullName = json['full_name'];
    steps = json['steps'];
    amount = json['amount'] != null ? double.parse(json['amount'].toString()) : 0;
    genderType = json['user_gender'].toString() == '2' ? GENDER_TYPE.WOMAN : GENDER_TYPE.MAN;
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_image'] = this.userImage;
    data['full_name'] = this.fullName;
    data['steps'] = this.steps;
    data['user_gender'] = this.genderType;
    data['amount'] = this.amount;
    data['type'] = this.type;
    return data;
  }
}
