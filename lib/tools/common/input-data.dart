import 'dart:io';

import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/tools/common/utlis.dart';
import 'package:flutter/material.dart';

class DataUtils {
  DataUtils._();

  static List<Map<String, dynamic>> genderData(BuildContext context) {
    return [
      {
        'keyword': '1',
        'key': "general__gender_options_male",
        'display': Utils.getString(context, "general__gender_options_male"),
      },
      {
        'keyword': '2',
        'key': "general__gender_options_female",
        'display': Utils.getString(context, "general__gender_options_female")
      },
    ];
  }


  static Map<String, dynamic> getHeader() {
    return {
      'Authorization': "Bearer $TOKEN",
      'Accept-Language': LANGUAGE,
      'Accept': 'application/json',
      'OS': Platform.isIOS ? '1' : '2'
    };
  }

}
