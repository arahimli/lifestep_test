import 'package:lifestep/model/auth/profile.dart';
import 'package:lifestep/model/donation/charities.dart';
import 'package:lifestep/model/donation/donors.dart';
import 'package:lifestep/model/donation/fonds.dart';
import 'package:lifestep/model/general/achievement-list.dart';

class FondDonationResponse {
  bool? status;
  FondDonationDataModel? data;
  String? message;

  FondDonationResponse({this.status, this.data, this.message});

  FondDonationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new FondDonationDataModel.fromJson(json['data']) : null;
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
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
    fond =
    json['fund'] != null ? new FondModel.fromJson(json['fund']) : null;
    donateCount = json['donate_count'];
    if (json['donates'] != null) {
      donates = <DonorModel>[];
      json['donates'].forEach((v) {
        donates!.add(new DonorModel.fromJson(v));
      });
    }
    if (json['user_achievements'] != null) {
      userAchievementsModels = <UserAchievementModel>[];
      json['user_achievements'].forEach((v) {
        userAchievementsModels!.add(new UserAchievementModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.fond != null) {
      data['fund'] = this.fond!.toJson();
    }
    data['donate_count'] = this.donateCount;
    if (this.donates != null) {
      data['donates'] = this.donates!.map((v) => v.toJson()).toList();
    }
    if (this.userAchievementsModels != null) {
      data['user_achievements'] = this.userAchievementsModels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}




