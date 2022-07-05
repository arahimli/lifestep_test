import 'package:lifestep/tools/constants/enum.dart';
import 'package:lifestep/model/challenge/challenges.dart';

class ParticipantListResponse {
  bool? status;
  ParticipantListModel? data;
  String? message;

  ParticipantListResponse({this.status, this.data, this.message});

  ParticipantListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new ParticipantListModel.fromJson(json['data']) : null;
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

class ParticipantListModel {
  int? count;
  List<ParticipantModel>? users;

  ParticipantListModel({this.count, this.users});

  ParticipantListModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['users'] != null) {
      users = <ParticipantModel>[];
      json['users'].forEach((v) {
        users!.add(new ParticipantModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ParticipantModel {
  int? id;
  String? userImage;
  String? fullName;
  GENDER_TYPE? genderType;
  int? km;
  int? time;
  String? lat;
  String? long;
  ChallengeModel? challenge;
  String? joinDate;

  ParticipantModel(
      {this.id,
        this.userImage,
        this.fullName,
        this.genderType,
        this.km,
        this.time,
        this.lat,
        this.long,
        this.challenge,
        this.joinDate});

  ParticipantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userImage = json['user_image'];
    fullName = json['full_name'];
    genderType = json['user_gender'].toString() == '2' ? GENDER_TYPE.WOMAN : GENDER_TYPE.MAN;
    km = json['km'];
    time = json['time'];
    lat = json['lat'];
    long = json['long'];
    challenge = json['challenge'] != null
        ? new ChallengeModel.fromJson(json['challenge'])
        : null;
    joinDate = json['join_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_image'] = this.userImage;
    data['full_name'] = this.fullName;
    data['user_gender'] = this.genderType;
    data['km'] = this.km;
    data['time'] = this.time;
    data['lat'] = this.lat;
    data['long'] = this.long;
    if (this.challenge != null) {
      data['challenge'] = this.challenge!.toJson();
    }
    data['join_date'] = this.joinDate;
    return data;
  }
}


