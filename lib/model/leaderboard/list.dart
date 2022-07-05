import 'package:lifestep/tools/constants/enum.dart';

class UsersRatingResponse {
  int? status;
  UsersRatingDataModel? data;
  String? message;

  UsersRatingResponse({this.status, this.data, this.message});

  UsersRatingResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new UsersRatingDataModel.fromJson(json['data']) : null;
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

class UsersRatingDataModel {
  List<UsersRatingModel>? usersWeeklyRating;
  List<UsersRatingModel>? usersMonthlyRating;
  List<UsersRatingModel>? usersAllRating;

  UsersRatingDataModel({this.usersWeeklyRating, this.usersMonthlyRating, this.usersAllRating});

  UsersRatingDataModel.fromJson(Map<String, dynamic> json) {
    if (json['users_weekly_rating'] != null) {
      usersWeeklyRating = <UsersRatingModel>[];
      json['users_weekly_rating'].forEach((v) {
        usersWeeklyRating!.add(new UsersRatingModel.fromJson(v));
      });
    }
    if (json['users_monthly_rating'] != null) {
      usersMonthlyRating = <UsersRatingModel>[];
      json['users_monthly_rating'].forEach((v) {
        usersMonthlyRating!.add(new UsersRatingModel.fromJson(v));
      });
    }
    if (json['users_all_rating'] != null) {
      usersAllRating = <UsersRatingModel>[];
      json['users_all_rating'].forEach((v) {
        usersAllRating!.add(new UsersRatingModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.usersWeeklyRating != null) {
      data['users_weekly_rating'] =
          this.usersWeeklyRating!.map((v) => v.toJson()).toList();
    }
    if (this.usersMonthlyRating != null) {
      data['users_monthly_rating'] =
          this.usersMonthlyRating!.map((v) => v.toJson()).toList();
    }
    if (this.usersAllRating != null) {
      data['users_all_rating'] =
          this.usersAllRating!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UsersRatingModel {
  int? id;
  int? userId;
  GENDER_TYPE? genderType;
  String? name;
  String? image;
  int? steps;

  UsersRatingModel({this.id, this.userId, this.name, this.image, this.steps, this.genderType,});

  UsersRatingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    genderType = json['user_gender'].toString() == '2' ? GENDER_TYPE.WOMAN : GENDER_TYPE.MAN;
    steps = json['steps'] != null ? int.parse(json['steps'].toString()) : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['user_gender'] = this.genderType;
    data['steps'] = this.steps;
    return data;
  }
}
