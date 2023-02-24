import 'package:lifestep/features/main_app/data/models/auth/profile.dart';
import 'package:lifestep/features/tools/common/utlis.dart';

class OtpResponse {
  bool? status;
  OtpDataModel? data;
  String? message;

  OtpResponse({this.status, this.data, this.message});

  OtpResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? OtpDataModel.fromJson(json['data']) : null;
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


class OtpDataModel {
  UserModel? user;
  String? otp;
  String? token;

  OtpDataModel({this.user, this.otp, this.token});

  OtpDataModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    otp = Utils.checkNullToString(json['otp']);
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['otp'] = otp;
    data['token'] = token;
    return data;
  }
}
