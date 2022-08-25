

class StepBaseParticipantListResponse {
  bool? status;
  List<StepBaseParticipantModel>? data;
  String? message;

  StepBaseParticipantListResponse({this.status, this.data, this.message});

  StepBaseParticipantListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <StepBaseParticipantModel>[];
      json['data'].forEach((v) {
        data!.add(new StepBaseParticipantModel.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class StepBaseParticipantModel {
  int? id;
  String? userImage;
  String? fullName;
  int? steps;
  String? joinDate;

  StepBaseParticipantModel({this.id, this.userImage, this.fullName, this.steps, this.joinDate});

  StepBaseParticipantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userImage = json['user_image'];
    fullName = json['full_name'];
    steps = json['steps'] ?? 0;
    joinDate = json['join_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['user_image'] = userImage;
    data['full_name'] = fullName;
    data['steps'] = steps;
    data['join_date'] = joinDate;
    return data;
  }
}
