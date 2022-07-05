import 'package:lifestep/model/auth/profile.dart';

class OtpResponse {
  bool? status;
  OtpDataModel? data;
  String? message;

  OtpResponse({this.status, this.data, this.message});

  OtpResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new OtpDataModel.fromJson(json['data']) : null;
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


class OtpDataModel {
  UserModel? user;
  String? otp;
  String? token;

  OtpDataModel({this.user, this.otp, this.token});

  OtpDataModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
    otp = json['otp'] != null ? json['otp'].toString() : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['otp'] = this.otp;
    data['token'] = this.token;
    return data;
  }
}
