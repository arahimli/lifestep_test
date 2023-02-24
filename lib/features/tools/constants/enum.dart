// part '';

import 'package:lifestep/features/tools/config/main_config.dart';

enum ConnectionType { wifi, mobile }

enum CHALLENGE_TYPE { step, checkPoint }

enum GENDER_TYPE { man, woman }

extension GenderTypeExtension on GENDER_TYPE {

  String get getValue{
    switch(this){
      case GENDER_TYPE.man:{
        return '1';
      }
      case GENDER_TYPE.woman:{
        return '2';
      }
      default:{
        return '1';
      }
    }
  }

  String get getImage{
    switch(this){
      case GENDER_TYPE.man:{
        return MainConfig.defaultMan;
      }
      case GENDER_TYPE.woman:{
        return MainConfig.defaultWoman;
      }
      default:{
        return MainConfig.defaultMan;
      }
    }
  }
}

enum IMAGE_TYPE { svg, image }

enum USER_ORDER_STEP_TYPE {
  donationWeek,
  donationMonth,
  donationAll,
  stepWeek,
  stepMonth,
  stepAll,
}