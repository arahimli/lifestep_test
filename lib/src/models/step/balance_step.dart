import 'package:lifestep/src/models/auth/profile.dart';
import 'package:lifestep/src/models/general/achievement_list.dart';

class BalanceStepResponse {
  bool? status;
  BalanceStepData? data;
  String? message;

  BalanceStepResponse({this.status, this.data, this.message});

  BalanceStepResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? BalanceStepData.fromJson(json['data']) : null;
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

class BalanceStepData {
  UserModel? user;
  List<UserAchievementModel>? userAchievements;

  BalanceStepData({this.user, this.userAchievements});

  BalanceStepData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;

    if (json['user_achievements'] != null) {
      userAchievements = <UserAchievementModel>[];
      json['user_achievements'].forEach((v) {
        userAchievements!.add(UserAchievementModel.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }

    if (userAchievements != null) {
      data['user_achievements'] = userAchievements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

