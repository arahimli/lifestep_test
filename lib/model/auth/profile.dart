import 'package:lifestep/tools/common/utlis.dart';
import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/tools/constants/enum.dart';
import 'package:sprintf/sprintf.dart';
import 'package:lifestep/pages/user/logic/cubit.dart';

class ProfileResponse {
  bool? status;
  UserModel? data;
  String? message;

  ProfileResponse({this.status, this.data, this.message});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new UserModel.fromJson(json['data']) : null;
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

class UserModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? role;
  AuthType loginMethod = AuthType.OTP;
  String? otp;
  int? confirmed;
  int? signed;
  String? gender;
  GENDER_TYPE? genderType;
  String? dob;
  String? image;
  String? weight;
  String? height;
  int? targetSteps;
  int? totalDonateSteps;
  int? balanceSteps;
  int? balanceSteps2;
  double? totalDonations;
  String? invitationCode;
  String? emailVerifiedAt;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  UserModel(
      {this.id,
        this.name,
        this.email,
        this.phone,
        this.role,
        required this.loginMethod,
        this.otp,
        this.confirmed,
        this.signed,
        this.gender,
        this.genderType,
        this.dob,
        this.image,
        this.weight,
        this.height,
        this.targetSteps,
        this.totalDonateSteps,
        this.balanceSteps,
        this.balanceSteps2,
        this.totalDonations,
        this.invitationCode,
        this.emailVerifiedAt,
        this.deletedAt,
        this.createdAt,
        this.updatedAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'] != null ? json['phone'].toString().replaceAll("+994", '').replaceAll("(994)", '').replaceAll(" ", '').replaceAll("-", '') : '';
    role = json['role'];
    switch(json['login_method']){
      case 'apple': {
        loginMethod = AuthType.APPLE;
      }break;
      case 'facebook': {
        loginMethod = AuthType.FACEBOOK;
      }break;
      case 'google': {
        loginMethod = AuthType.GOOGLE;
      }break;
      default:{
        loginMethod = AuthType.OTP;
      }break;
    }
    otp = json['otp'] != null ? json['otp'].toString() : '';
    confirmed = json['confirmed'];
    signed = json['signed'];
    gender = json['gender'] != null ? json['gender'].toString() : null;
    genderType = json['user_gender'].toString() == '2' ? GENDER_TYPE.WOMAN : GENDER_TYPE.MAN;
    dob = json['dob'] != null ? Utils.stringToDatetoString(value: json['dob'], formatFrom: "yyyy-MM-dd", formatTo: "dd.MM.yyyy") : '';
    image = json['image'] != null ? sprintf( IMAGE_URL , [json['image']]) : null;
    weight = json['weight'] != null ? json['weight'].toString() : '';
    height = json['height'] != null ? json['height'].toString() : '';
    targetSteps = Utils.stringToInt(value: json['target_steps'] != null ? json['target_steps'].toString() : null );
    totalDonateSteps = json['total_donate_steps'];
    balanceSteps = json['balance_steps'] != null ? json['balance_steps'] < 0 ? 0 : json['balance_steps'] : 0;
    balanceSteps2 = json['balance2'];
    totalDonations = json['total_donations'] != null ? double.parse(json['total_donations'].toString()) : 0;;
    invitationCode = json['invitation_code'];
    emailVerifiedAt = json['email_verified_at'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['role'] = this.role;
    data['login_method'] = this.loginMethod;
    data['otp'] = this.otp;
    data['confirmed'] = this.confirmed;
    data['signed'] = this.signed;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['image'] = this.image;
    data['weight'] = this.weight;
    data['height'] = this.height;
    data['target_steps'] = this.targetSteps;
    data['total_donate_steps'] = this.totalDonateSteps;
    data['balance_steps'] = this.balanceSteps;
    data['balance2'] = this.balanceSteps2;
    data['total_donations'] = this.totalDonations;
    data['invitation_code'] = this.invitationCode;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
