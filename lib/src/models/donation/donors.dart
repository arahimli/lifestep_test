
import 'package:lifestep/src/tools/constants/enum.dart';

class DonorListResponse {
  bool? status;
  DonorListModel? data;
  String? message;

  DonorListResponse({this.status, this.data, this.message});

  DonorListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? DonorListModel.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
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
        donates!.add(DonorModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['donate_count'] = donateCount;
    if (donates != null) {
      data['donates'] = donates!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['user_image'] = userImage;
    data['full_name'] = fullName;
    data['steps'] = steps;
    data['user_gender'] = genderType;
    data['amount'] = amount;
    data['type'] = type;
    return data;
  }
}
