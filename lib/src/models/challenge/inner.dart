import 'challenges.dart';

class StepBaseStageResponse {
  bool? status;
  StepBaseStageData? data;
  String? message;

  StepBaseStageResponse({this.status, this.data, this.message});

  StepBaseStageResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new StepBaseStageData.fromJson(json['data']) : null;
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
}

class StepBaseStageData {
  ChallengeModel? challenge;
  List<ChallengeLevelModel>? challengeLevels;
  int? userSteps;

  StepBaseStageData({this.challenge, this.challengeLevels, this.userSteps});

  StepBaseStageData.fromJson(Map<String, dynamic> json) {
    challenge = json['challenge'] != null
        ? new ChallengeModel.fromJson(json['challenge'])
        : null;
    if (json['challenge_levels'] != null) {
      challengeLevels = <ChallengeLevelModel>[];
      json['challenge_levels'].forEach((v) {
        challengeLevels!.add(new ChallengeLevelModel.fromJson(v));
      });
    }
    userSteps = json['user_steps'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (challenge != null) {
      data['challenge'] = challenge!.toJson();
    }
    if (challengeLevels != null) {
      data['challenge_levels'] =
          challengeLevels!.map((v) => v.toJson()).toList();
    }
    data['user_steps'] = userSteps;
    return data;
  }
}


class ChallengeLevelModel {
  int? id;
  int? goal;
  String? prizeName;

  ChallengeLevelModel({this.id, this.goal, this.prizeName});

  ChallengeLevelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    goal = json['goal'] ?? 0;
    prizeName = json['prize_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['goal'] = goal;
    data['prize_name'] = prizeName;
    return data;
  }
}
