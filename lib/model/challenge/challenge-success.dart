import 'package:lifestep/model/auth/profile.dart';
import 'package:lifestep/model/challenge/challenges.dart';
import 'package:lifestep/model/challenge/participants.dart';

class ChallengeSuccessResponse {
  bool? status;
  Data? data;
  String? message;

  ChallengeSuccessResponse({this.status, this.data, this.message});

  ChallengeSuccessResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  JoinedUser? joinedUser;
  int? count;
  List<ParticipantModel>? challengeUsers;

  Data({this.joinedUser, this.count, this.challengeUsers});

  Data.fromJson(Map<String, dynamic> json) {
    joinedUser = json['joined_user'] != null
        ? new JoinedUser.fromJson(json['joined_user'])
        : null;
    count = json['count'];
    if (json['challenge_users'] != null) {
      challengeUsers = <ParticipantModel>[];
      json['challenge_users'].forEach((v) {
        challengeUsers!.add(new ParticipantModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.joinedUser != null) {
      data['joined_user'] = this.joinedUser!.toJson();
    }
    data['count'] = this.count;
    if (this.challengeUsers != null) {
      data['challenge_users'] =
          this.challengeUsers!.map((v) => v.toJson()).toList();
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
        ? new ChallengeModel.fromJson(json['challenge'])
        : null;
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['challenge_id'] = this.challengeId;
    data['km'] = this.km;
    data['time'] = this.time;
    data['steps'] = this.steps;
    data['success'] = this.success;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.challenge != null) {
      data['challenge'] = this.challenge!.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}
