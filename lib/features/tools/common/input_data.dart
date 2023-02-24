import 'dart:io';

import 'package:lifestep/features/main_app/data/models/config/settings.dart';
import 'package:lifestep/features/tools/config/endpoints.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:flutter/material.dart';
import 'package:lifestep/features/tools/config/get_it.dart';

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
      'Authorization': "Bearer ${sl<Settings>().accessToken}",
      'Accept-Language': languageGlobal,
      'Accept': 'application/json',
      'OS': Platform.isIOS ? '1' : '2'
    };
  }

}
