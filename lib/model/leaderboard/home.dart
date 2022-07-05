import 'list.dart';

class HomeLeaderBoardResponse {
  int? status;
  List<UsersRatingModel>? data;
  String? message;

  HomeLeaderBoardResponse({this.status, this.data, this.message});

  HomeLeaderBoardResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <UsersRatingModel>[];
      json['data'].forEach((v) {
        data!.add(new UsersRatingModel.fromJson(v));
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