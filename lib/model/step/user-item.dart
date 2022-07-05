import 'package:lifestep/tools/constants/enum.dart';
import 'package:lifestep/model/challenge/challenges.dart';




class UserStepOrderModel {
  int? id;
  String? userImage;
  String? fullName;
  GENDER_TYPE? genderType;
  int? step;

  UserStepOrderModel(
      {this.id,
        this.userImage,
        this.fullName,
        this.genderType,
        this.step,});

  UserStepOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userImage = json['user_image'];
    fullName = json['full_name'];
    genderType = json['user_gender'].toString() == '2' ? GENDER_TYPE.WOMAN : GENDER_TYPE.MAN;
    step = json['step'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_image'] = this.userImage;
    data['full_name'] = this.fullName;
    data['user_gender'] = this.genderType;
    data['step'] = this.step;
    return data;
  }
}


