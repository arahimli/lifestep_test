import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/model/challenge/challenges.dart';
import 'package:lifestep/model/donation/charities.dart';
import 'package:sprintf/sprintf.dart';

class AchievementListResponse {
  bool? status;
  Data? data;
  String? message;

  AchievementListResponse({this.status, this.data, this.message});

  AchievementListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  List<AchievementModel>? achievements;
  List<UserAchievementModel>? userAchievements;

  Data({this.achievements, this.userAchievements});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['achievements'] != null) {
      achievements = <AchievementModel>[];
      json['achievements'].forEach((v) {
        achievements!.add(AchievementModel.fromJson(v));
      });
    }
    if (json['user_achievements'] != null) {
      userAchievements = <UserAchievementModel>[];
      json['user_achievements'].forEach((v) {
        userAchievements!.add(UserAchievementModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.achievements != null) {
      data['achievements'] = this.achievements!.map((v) => v.toJson()).toList();
    }
    if (this.userAchievements != null) {
      data['user_achievements'] =
          this.userAchievements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AchievementModel {
  int? id;
  String? name;
  String? description;
  String? unlcokImage;
  String? lockImage;
  int? steps;
  int? isPeriodic;
  int? charityProgress;
  String? type;

  AchievementModel(
      {this.id,
        this.name,
        this.description,
        this.unlcokImage,
        this.lockImage,
        this.steps,
        this.isPeriodic,
        this.charityProgress,
        this.type});

  AchievementModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    lockImage = json['image'] != null ? sprintf( IMAGE_URL , [json['image']]) : null;
    unlcokImage = json['image_unlocked'] != null ? sprintf( IMAGE_URL , [json['image_unlocked']]) : null;
    steps = json['steps'];
    isPeriodic = json['is_periodic'];
    charityProgress = json['charity_progress'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.lockImage;
    data['image_unlocked'] = this.unlcokImage;
    data['steps'] = this.steps;
    data['is_periodic'] = this.isPeriodic;
    data['charity_progress'] = this.charityProgress;
    data['type'] = this.type;
    return data;
  }
}

class UserAchievementModel {
  int? id;
  int? achievementId;
  String? name;
  String? description;
  String? image;
  String? imageUnlocked;
  int? isPeriodic;
  int? periodicNumber;
  int? steps;
  String? type;
  CharityModel? charity;
  ChallengeModel? challenge;

  UserAchievementModel(
      {this.id,
        this.achievementId,
        this.name,
        this.description,
        this.image,
        this.imageUnlocked,
        this.isPeriodic,
        this.periodicNumber,
        this.steps,
        this.type,
        this.charity,
        this.challenge});

  UserAchievementModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    achievementId = json['achievement_id'];
    name = json['name'];
    description = json['description'];
    image = json['image'] != null ? sprintf( IMAGE_URL , [json['image']]) : null;
    imageUnlocked = json['image_unlocked'] != null ? sprintf( IMAGE_URL , [json['image_unlocked']]) : null;
    isPeriodic = json['is_periodic'];
    periodicNumber = json['periodic_number'];
    steps = json['steps'];
    type = json['type'];
    charity =
    json['charity'] != null ? CharityModel.fromJson(json['charity']) : null;
    challenge = json['challenge'] != null
        ? ChallengeModel.fromJson(json['challenge'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['achievement_id'] = this.achievementId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['image_unlocked'] = this.imageUnlocked;
    data['is_periodic'] = this.isPeriodic;
    data['periodic_number'] = this.periodicNumber;
    data['steps'] = this.steps;
    data['type'] = this.type;
    if (this.charity != null) {
      data['charity'] = this.charity!.toJson();
    }
    if (this.challenge != null) {
      data['challenge'] = this.challenge!.toJson();
    }
    return data;
  }
}

