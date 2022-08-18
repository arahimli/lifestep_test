import 'package:lifestep/src/models/auth/profile.dart';

class SocialLoginResponse {
  bool? status;
  SocialLoginModel? data;
  String? message;

  SocialLoginResponse({this.status, this.data, this.message});

  SocialLoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? SocialLoginModel.fromJson(json['data']) : null;
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

class SocialLoginModel {
  UserModel? user;
  String? token;

  SocialLoginModel({this.user, this.token});

  SocialLoginModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token'] = token;
    return data;
  }
}
