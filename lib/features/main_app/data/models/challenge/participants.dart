import 'package:lifestep/features/tools/constants/enum.dart';
import 'package:lifestep/features/main_app/data/models/challenge/challenges.dart';

class ParticipantListResponse {
  bool? status;
  ParticipantListModel? data;
  String? message;

  ParticipantListResponse({this.status, this.data, this.message});

  ParticipantListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? ParticipantListModel.fromJson(json['data']) : null;
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

class ParticipantListModel {
  int? count;
  List<ParticipantModel>? users;

  ParticipantListModel({this.count, this.users});

  ParticipantListModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['users'] != null) {
      users = <ParticipantModel>[];
      json['users'].forEach((v) {
        users!.add(ParticipantModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['count'] = count;
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ParticipantModel {
  int? id;
  String? userImage;
  String? fullName;
  late GENDER_TYPE genderType;
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
        required this.genderType,
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
    genderType = json['user_gender'].toString() == '2' ? GENDER_TYPE.woman : GENDER_TYPE.man;
    km = json['km'];
    time = json['time'];
    lat = json['lat'];
    long = json['long'];
    challenge = json['challenge'] != null
        ? ChallengeModel.fromJson(json['challenge'])
        : null;
    joinDate = json['join_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['user_image'] = userImage;
    data['full_name'] = fullName;
    data['user_gender'] = genderType;
    data['km'] = km;
    data['time'] = time;
    data['lat'] = lat;
    data['long'] = long;
    if (challenge != null) {
      data['challenge'] = challenge!.toJson();
    }
    data['join_date'] = joinDate;
    return data;
  }
}


