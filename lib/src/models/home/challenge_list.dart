
import 'dart:developer';

import 'package:lifestep/src/models/challenge/challenges.dart';
import 'package:lifestep/src/models/challenge/inner.dart';

import '../base.dart';

class HomeChallengeListResponse extends Model{
  bool? status;
  HomeChallengeListResponseData? data;
  String? message;

  HomeChallengeListResponse({this.status, this.data, this.message});

  HomeChallengeListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? HomeChallengeListResponseData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status, data];
}

class HomeChallengeListResponseData {
  List<ChallengeModel>? challenges;
  List<StepInnerModel>? stepInner;

  HomeChallengeListResponseData({this.challenges, this.stepInner});

  HomeChallengeListResponseData.fromJson(Map<String, dynamic> json) {
    if (json['challenges'] != null) {
      challenges = <ChallengeModel>[];
      json['challenges'].forEach((v) {
        challenges!.add(new ChallengeModel.fromJson(v));
      });
    }
    if (json['step_inner'] != null) {
      stepInner = <StepInnerModel>[];
      json['step_inner'].forEach((v) {
        log("[LOG] : json['step_inner'] ${v.toString()}");
        try {
          stepInner!.add(StepInnerModel.fromJson(v));
        }catch(e){}
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (challenges != null) {
      data['challenges'] = challenges!.map((v) => v.toJson()).toList();
    }
    if (this.stepInner != null) {
      data['step_inner'] = this.stepInner!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class StepInnerModel {
  List<ChallengeLevelModel>? challengeLevels;
  int? userSteps;

  StepInnerModel({this.challengeLevels, this.userSteps});

  StepInnerModel.fromJson(Map<String, dynamic> json) {
    if (json['challenge_levels'] != null) {
      challengeLevels = <ChallengeLevelModel>[];
      json['challenge_levels'].forEach((v) {
        challengeLevels!.add(new ChallengeLevelModel.fromJson(v));
      });
    }
    userSteps = json['user_steps'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (challengeLevels != null) {
      data['challenge_levels'] =
          challengeLevels!.map((v) => v.toJson()).toList();
    }
    data['user_steps'] = userSteps;
    return data;
  }
}

