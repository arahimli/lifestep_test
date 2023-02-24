import 'package:lifestep/features/tools/constants/enum.dart';

class UsersRatingResponse {
  int? status;
  UsersRatingDataModel? data;
  String? message;

  UsersRatingResponse({this.status, this.data, this.message});

  UsersRatingResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? UsersRatingDataModel.fromJson(json['data']) : null;
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

class UsersRatingDataModel {
  List<UsersRatingModel>? usersWeeklyRating;
  List<UsersRatingModel>? usersMonthlyRating;
  List<UsersRatingModel>? usersAllRating;

  UsersRatingDataModel({this.usersWeeklyRating, this.usersMonthlyRating, this.usersAllRating});

  UsersRatingDataModel.fromJson(Map<String, dynamic> json) {
    if (json['users_weekly_rating'] != null) {
      usersWeeklyRating = <UsersRatingModel>[];
      json['users_weekly_rating'].forEach((v) {
        usersWeeklyRating!.add(UsersRatingModel.fromJson(v));
      });
    }
    if (json['users_monthly_rating'] != null) {
      usersMonthlyRating = <UsersRatingModel>[];
      json['users_monthly_rating'].forEach((v) {
        usersMonthlyRating!.add(UsersRatingModel.fromJson(v));
      });
    }
    if (json['users_all_rating'] != null) {
      usersAllRating = <UsersRatingModel>[];
      json['users_all_rating'].forEach((v) {
        usersAllRating!.add(UsersRatingModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    if (usersWeeklyRating != null) {
      data['users_weekly_rating'] =
          usersWeeklyRating!.map((v) => v.toJson()).toList();
    }
    if (usersMonthlyRating != null) {
      data['users_monthly_rating'] =
          usersMonthlyRating!.map((v) => v.toJson()).toList();
    }
    if (usersAllRating != null) {
      data['users_all_rating'] =
          usersAllRating!.map((v) => v.toJson()).toList();
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
    genderType = json['user_gender'].toString() == '2' ? GENDER_TYPE.woman : GENDER_TYPE.man;
    steps = json['steps'] != null ? int.parse(json['steps'].toString()) : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['image'] = image;
    data['user_gender'] = genderType;
    data['steps'] = steps;
    return data;
  }
}
