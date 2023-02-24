
import 'dart:developer';

import 'package:lifestep/features/main_app/domain/repositories/home/repository.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:lifestep/features/tools/config/endpoint_config.dart';

class HomeRepository implements IHomeRepository{

  @override
  Future<List> getSlider() async {
    String requestUrl = EndpointConfig.getSlider;
    log(requestUrl);
    List data = await WebService.getCall(url: requestUrl);
    log(requestUrl);
    return data;
  }

  // @override
  Future<List> homeCharities() async {
    String requestUrl = EndpointConfig.homeCharities;
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }

  @override
  Future<List> homeFonds() async {
    String requestUrl = EndpointConfig.homeFunds;
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }

  @override
  Future<List> homeChallenges() async {
    String requestUrl = EndpointConfig.homeChallenges;
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }
}


