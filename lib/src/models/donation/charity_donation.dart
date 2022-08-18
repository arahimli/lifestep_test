import 'package:lifestep/src/models/auth/profile.dart';
import 'package:lifestep/src/models/donation/charities.dart';
import 'package:lifestep/src/models/donation/donors.dart';
import 'package:lifestep/src/models/general/achievement-list.dart';

class CharityDonationResponse {
  bool? status;
  CharityDonationDataModel? data;
  String? message;

  CharityDonationResponse({this.status, this.data, this.message});

  CharityDonationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? CharityDonationDataModel.fromJson(json['data']) : null;
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

class CharityDonationDataModel {
  UserModel? user;
  CharityModel? charity;
  int? donateCount;
  List<DonorModel>? donates;
  List<UserAchievementModel>? userAchievementsModels;

  CharityDonationDataModel(
      {
        this.user,
        this.charity,
        this.donateCount,
        this.donates,
        this.userAchievementsModels
      });

  CharityDonationDataModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    charity =
    json['charity'] != null ? CharityModel.fromJson(json['charity']) : null;
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
    if (charity != null) {
      data['charity'] = charity!.toJson();
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




