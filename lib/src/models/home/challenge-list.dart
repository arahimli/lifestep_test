
import 'package:lifestep/src/models/challenge/challenges.dart';

class HomeChallengeListResponse {
  bool? status;
  List<ChallengeModel>? data;
  String? message;

  HomeChallengeListResponse({this.status, this.data, this.message});

  HomeChallengeListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <ChallengeModel>[];
      json['data'].forEach((v) {
        data!.add(ChallengeModel.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}
