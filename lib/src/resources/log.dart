

import 'dart:developer';

import 'package:lifestep/src/tools/config/endpoint_config.dart';

import 'service/web_service.dart';

abstract class ILogRepository{
  Future<List> sendingLogInfo(Map<String, dynamic> mainData, Map<String, dynamic>? headers); // => staticProvider.getTermsPrivacy();
}

class LogRepository extends ILogRepository {

  @override
  Future<List> sendingLogInfo(Map<String, dynamic> mainData, Map<String, dynamic>? headers) async {
    String requestUrl = EndpointConfig.sendingLogInfo;
    List data = await WebService.postCall(url: requestUrl, data: mainData, headers: headers);
    log(data[1].toString());
    return data;
  }

}