import 'package:lifestep/src/tools/constants/enum.dart';




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
    final Map<String, dynamic>  data = <String,dynamic>{};
    data['id'] = id;
    data['user_image'] = userImage;
    data['full_name'] = fullName;
    data['user_gender'] = genderType;
    data['step'] = step;
    return data;
  }
}


