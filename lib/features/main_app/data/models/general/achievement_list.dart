import 'package:lifestep/features/tools/config/endpoint_config.dart';
import 'package:lifestep/features/main_app/data/models/challenge/challenges.dart';
import 'package:lifestep/features/main_app/data/models/donation/charities.dart';
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
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
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
    final Map<String, dynamic>  data = <String,dynamic>{};
    if (achievements != null) {
      data['achievements'] = achievements!.map((v) => v.toJson()).toList();
    }
    if (userAchievements != null) {
      data['user_achievements'] =
          userAchievements!.map((v) => v.toJson()).toList();
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
    lockImage = json['image'] != null ? sprintf( EndpointConfig.imageUrl , [json['image']]) : null;
    unlcokImage = json['image_unlocked'] != null ? sprintf( EndpointConfig.imageUrl , [json['image_unlocked']]) : null;
    steps = json['steps'];
    isPeriodic = json['is_periodic'];
    charityProgress = json['charity_progress'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = lockImage;
    data['image_unlocked'] = unlcokImage;
    data['steps'] = steps;
    data['is_periodic'] = isPeriodic;
    data['charity_progress'] = charityProgress;
    data['type'] = type;
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
    image = json['image'] != null ? sprintf( EndpointConfig.imageUrl , [json['image']]) : null;
    imageUnlocked = json['image_unlocked'] != null ? sprintf( EndpointConfig.imageUrl , [json['image_unlocked']]) : null;
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
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['achievement_id'] = achievementId;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['image_unlocked'] = imageUnlocked;
    data['is_periodic'] = isPeriodic;
    data['periodic_number'] = periodicNumber;
    data['steps'] = steps;
    data['type'] = type;
    if (charity != null) {
      data['charity'] = charity!.toJson();
    }
    if (challenge != null) {
      data['challenge'] = challenge!.toJson();
    }
    return data;
  }
}

