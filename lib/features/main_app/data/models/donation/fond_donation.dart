import 'package:lifestep/features/main_app/data/models/auth/profile.dart';
import 'package:lifestep/features/main_app/data/models/donation/donors.dart';
import 'package:lifestep/features/main_app/data/models/donation/fonds.dart';
import 'package:lifestep/features/main_app/data/models/general/achievement_list.dart';

class FondDonationResponse {
  bool? status;
  FondDonationDataModel? data;
  String? message;

  FondDonationResponse({this.status, this.data, this.message});

  FondDonationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? FondDonationDataModel.fromJson(json['data']) : null;
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

class FondDonationDataModel {
  UserModel? user;
  FondModel? fond;
  int? donateCount;
  List<DonorModel>? donates;
  List<UserAchievementModel>? userAchievementsModels;

  FondDonationDataModel(
      {
        this.user,
        this.fond,
        this.donateCount,
        this.donates,
        this.userAchievementsModels
      });

  FondDonationDataModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    fond =
    json['fund'] != null ? FondModel.fromJson(json['fund']) : null;
    donateCount = json['donate_count'];
    if (json['donates'] != null) {
      donates = <DonorModel>[];
      json['donates'].forEach((v) {
        donates!.add(DonorModel.fromJson(v));
      });
    }
    if (json['user_achievements'] != null) {
      userAchievementsModels = <UserAchievementModel>[];
      json['user_achievements'].forEach((v) {
        userAchievementsModels!.add(UserAchievementModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (fond != null) {
      data['fund'] = fond!.toJson();
    }
    data['donate_count'] = donateCount;
    if (donates != null) {
      data['donates'] = donates!.map((v) => v.toJson()).toList();
    }
    if (userAchievementsModels != null) {
      data['user_achievements'] = userAchievementsModels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




