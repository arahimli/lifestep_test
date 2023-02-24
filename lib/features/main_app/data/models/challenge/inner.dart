import 'challenges.dart';

class StepBaseStageResponse {
  bool? status;
  StepBaseStageData? data;
  String? message;

  StepBaseStageResponse({this.status, this.data, this.message});

  StepBaseStageResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? StepBaseStageData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
        ? ChallengeModel.fromJson(json['challenge'])
        : null;
    if (json['challenge_levels'] != null) {
      challengeLevels = <ChallengeLevelModel>[];
      json['challenge_levels'].forEach((v) {
        challengeLevels!.add(ChallengeLevelModel.fromJson(v));
      });
    }
    // log("[LOG] user_steps " + json['user_steps'].toString());
    // log("[LOG] user_steps " + json['user_steps'].runtimeType.toString());
    userSteps = json['user_steps'] != null ? int.parse(json['user_steps'].toString()) : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['goal'] = goal;
    data['prize_name'] = prizeName;
    return data;
  }
}
