import 'package:lifestep/model/auth/profile.dart';

class SocialLoginResponse {
  bool? status;
  SocialLoginModel? data;
  String? message;

  SocialLoginResponse({this.status, this.data, this.message});

  SocialLoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new SocialLoginModel.fromJson(json['data']) : null;
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

class SocialLoginModel {
  UserModel? user;
  String? token;

  SocialLoginModel({this.user, this.token});

  SocialLoginModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}
