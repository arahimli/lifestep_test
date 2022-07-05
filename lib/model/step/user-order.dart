
import 'package:equatable/equatable.dart';

class UserOrderResponse{
  int? status;
  UserOrderModel? data;
  String? message;

  UserOrderResponse({this.status, this.data, this.message});

  UserOrderResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new UserOrderModel.fromJson(json['data']) : null;
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

  @override
  // TODO: implement props
  List<Object?> get props => [this.data?.userRating?.steps, this.data?.number];
}

class UserOrderModel extends Equatable {
  int? number;
  UserRatingModel? userRating;

  UserOrderModel({this.number, this.userRating});

  UserOrderModel.fromJson(Map<String, dynamic> json) {
    number = json['number'] ?? 0;
    try {
      userRating = json['user_rating'] != null && json['user_rating'] != "[]"
          ? new UserRatingModel.fromJson(json['user_rating'])
          : null;
    }catch(e){
      userRating = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    if (this.userRating != null) {
      data['user_rating'] = this.userRating!.toJson();
    }
    return data;
  }

  List<Object?> get props => [this.userRating?.steps, this.number];
}

class UserRatingModel extends Equatable {
  int? id;
  int? userId;
  String? name;
  Null? image;
  int? gender;
  int? steps;

  UserRatingModel(
      {this.id, this.userId, this.name, this.image, this.gender, this.steps});

  UserRatingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    gender = json['gender'];
    steps = json['steps'] != null ? int.parse(json['steps']) : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['gender'] = this.gender;
    data['steps'] = this.steps;
    return data;
  }

  List<Object?> get props => [this.steps];
}
