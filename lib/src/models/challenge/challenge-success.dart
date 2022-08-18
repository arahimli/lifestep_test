import 'package:lifestep/src/models/auth/profile.dart';
import 'package:lifestep/src/models/challenge/challenges.dart';
import 'package:lifestep/src/models/challenge/participants.dart';

class ChallengeSuccessResponse {
  bool? status;
  Data? data;
  String? message;

  ChallengeSuccessResponse({this.status, this.data, this.message});

  ChallengeSuccessResponse.fromJson(Map<String, dynamic> json) {
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
  JoinedUser? joinedUser;
  int? count;
  List<ParticipantModel>? challengeUsers;

  Data({this.joinedUser, this.count, this.challengeUsers});

  Data.fromJson(Map<String, dynamic> json) {
    joinedUser = json['joined_user'] != null
        ? JoinedUser.fromJson(json['joined_user'])
        : null;
    count = json['count'];
    if (json['challenge_users'] != null) {
      challengeUsers = <ParticipantModel>[];
      json['challenge_users'].forEach((v) {
        challengeUsers!.add(ParticipantModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    if (joinedUser != null) {
      data['joined_user'] = joinedUser!.toJson();
    }
    data['count'] = count;
    if (challengeUsers != null) {
      data['challenge_users'] =
          challengeUsers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JoinedUser {
  int? id;
  int? userId;
  int? challengeId;
  String? km;
  String? time;
  String? steps;
  String? success;
  double? lat;
  double? long;
  String? createdAt;
  String? updatedAt;
  ChallengeModel? challenge;
  UserModel? user;

  JoinedUser(
      {this.id,
        this.userId,
        this.challengeId,
        this.km,
        this.time,
        this.steps,
        this.success,
        this.lat,
        this.long,
        this.createdAt,
        this.updatedAt,
        this.challenge,
        this.user});

  JoinedUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    challengeId = json['challenge_id'];
    km = json['km'].toString();
    time = json['time'].toString();
    steps = json['steps'].toString();
    success = json['success'].toString();
    lat = json['lat'];
    long = json['long'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    challenge = json['challenge'] != null
        ? ChallengeModel.fromJson(json['challenge'])
        : null;
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['challenge_id'] = challengeId;
    data['km'] = km;
    data['time'] = time;
    data['steps'] = steps;
    data['success'] = success;
    data['lat'] = lat;
    data['long'] = long;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (challenge != null) {
      data['challenge'] = challenge!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
