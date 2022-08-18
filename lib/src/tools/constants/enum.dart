// part '';

import 'package:lifestep/src/tools/config/main_config.dart';

enum ConnectionType { wifi, mobile }

enum CHALLENGE_TYPE { STEP, CHECKPOINT }

enum GENDER_TYPE { MAN, WOMAN }

extension GENDER_TYPEExtension on GENDER_TYPE {

  String get getValue{
    switch(this){
      case GENDER_TYPE.MAN:{
        return '1';
      }
      case GENDER_TYPE.WOMAN:{
        return '2';
      }
      default:{
        return '1';
      }
    }
  }

  String get getImage{
    switch(this){
      case GENDER_TYPE.MAN:{
        return MainConfig.defaultMan;
      }
      case GENDER_TYPE.WOMAN:{
        return MainConfig.defaultWoman;
      }
      default:{
        return MainConfig.defaultMan;
      }
    }
  }
}

enum IMAGE_TYPE { SVG, IMAGE }

enum USER_ORDER_STEP_TYPE {
  DONATION_WEEK,
  DONATION_MONTH,
  DONATION_ALL,
  STEP_WEEK,
  STEP_MONTH,
  STEP_ALL,
}