
import 'package:equatable/equatable.dart';

class UserOrderResponse{
  int? status;
  UserOrderModel? data;
  String? message;

  UserOrderResponse({this.status, this.data, this.message});

  UserOrderResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? UserOrderModel.fromJson(json['data']) : null;
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

  @override
  // TODO: implement props
  List<Object?> get props => [data?.userRating?.steps, data?.number];
}

class UserOrderModel extends Equatable {
  int? number;
  UserRatingModel? userRating;

  UserOrderModel({this.number, this.userRating});

  UserOrderModel.fromJson(Map<String, dynamic> json) {
    number = json['number'] ?? 0;
    try {
      userRating = json['user_rating'] != null && json['user_rating'] != "[]"
          ? UserRatingModel.fromJson(json['user_rating'])
          : null;
    }catch(e){
      userRating = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['number'] = number;
    if (userRating != null) {
      data['user_rating'] = userRating!.toJson();
    }
    return data;
  }

  List<Object?> get props => [userRating?.steps, number];
}

class UserRatingModel extends Equatable {
  int? id;
  int? userId;
  String? name;
  String? image;
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
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['image'] = image;
    data['gender'] = gender;
    data['steps'] = steps;
    return data;
  }
  @override
  List<Object?> get props => [steps];
}
