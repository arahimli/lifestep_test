import 'package:lifestep/model/auth/profile.dart';
import 'package:lifestep/model/general/achievement-list.dart';

class BalanceStepResponse {
  bool? status;
  BalanceStepData? data;
  String? message;

  BalanceStepResponse({this.status, this.data, this.message});

  BalanceStepResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new BalanceStepData.fromJson(json['data']) : null;
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

class BalanceStepData {
  UserModel? user;
  List<UserAchievementModel>? userAchievements;

  BalanceStepData({this.user, this.userAchievements});

  BalanceStepData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;

    if (json['user_achievements'] != null) {
      userAchievements = <UserAchievementModel>[];
      json['user_achievements'].forEach((v) {
        userAchievements!.add(new UserAchievementModel.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }

    if (this.userAchievements != null) {
      data['user_achievements'] = this.userAchievements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

