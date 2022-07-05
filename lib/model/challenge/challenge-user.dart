class ChallengeUserResponse {
  bool? status;
  ChallengeUserModel? data;
  String? message;

  ChallengeUserResponse({this.status, this.data, this.message});

  ChallengeUserResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new ChallengeUserModel.fromJson(json['data']) : null;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['challenge_id'] = this.challengeId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
