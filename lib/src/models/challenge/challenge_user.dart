class ChallengeUserResponse {
  bool? status;
  ChallengeUserModel? data;
  String? message;

  ChallengeUserResponse({this.status, this.data, this.message});

  ChallengeUserResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? ChallengeUserModel.fromJson(json['data']) : null;
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

class ChallengeUserModel {
  int? userId;
  int? challengeId;
  String? updatedAt;
  String? createdAt;
  int? id;

  ChallengeUserModel(
      {this.userId, this.challengeId, this.updatedAt, this.createdAt, this.id});

  ChallengeUserModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    challengeId = json['challenge_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['user_id'] = userId;
    data['challenge_id'] = challengeId;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
