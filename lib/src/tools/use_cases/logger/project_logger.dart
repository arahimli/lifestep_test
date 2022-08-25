
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:lifestep/src/resources/log.dart';
import 'package:lifestep/src/tools/common/input_data.dart';
import 'package:lifestep/src/tools/constants/page_key.dart';
import 'package:sprintf/sprintf.dart';

class ProjectCustomLog{
  static ProjectCustomLog? _instance;

  static ProjectCustomLog get instance{
    _instance ??= ProjectCustomLog._init();
    return _instance!;
  }
  ProjectCustomLog._init();
  void logPageName<T>(T page) async{
    log(sprintf("[Generic LOG] logPageName: %s" ,[page.toString()]));
  }

  void sendData<T>(PageKeyModel key) async{

    log(sprintf("[Generic LOG] sendData: %s" ,[key.key]));
    compute<Map<String, dynamic>, List>(heavyTask, {
    'mainData': {
      'event_id': key.key
    },
    "headers": DataUtils.getHeader()
    }).then((value){
      log(sprintf("[Generic LOG] response: %s" ,[value[0].toString()]));
    });
  }

}

Future<List> heavyTask(Map<String, dynamic> data) async{
  final ILogRepository _logRepository = LogRepository();
  return await _logRepository.sendingLogInfo(data['mainData'], data['headers']);
}