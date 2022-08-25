import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lifestep/src/tools/config/endpoint_config.dart';
import 'package:lifestep/src/tools/config/endpoints.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/models/challenge/map.dart';
import 'package:lifestep/src/resources/service/web_service.dart';
import 'package:sprintf/sprintf.dart';

abstract class IChallengeRepository {


  Future<List> getChallenges({required String searchText, required int pageValue, required CancelToken token});
  Future<List> getChallengeParticipants({required String requestUrl, required CancelToken token});
  Future<List> getStepBaseStage({required String requestUrl, required CancelToken token});
  Future<List> joinChallenge({required String requestUrl, required Map<String, dynamic> mapData, required CancelToken token});
  Future<List> joinStepBaseChallenge({required String requestUrl, required Map<String, dynamic> mapData, required CancelToken token});
  Future<List> cancelStepBaseChallenge({required String requestUrl, required Map<String, dynamic> mapData, required CancelToken token});
  Future<List> successChallenge({required String requestUrl, required Map<String, dynamic> mapData, required CancelToken token});
  Future<List> cancelChallenge({required String requestUrl, required Map<String, dynamic> mapData, required CancelToken token});
  Future<List> getAddressInfo({required String requestUrl, required Map<String, dynamic> headers, required CancelToken token});
  Future<List<int>> getDistanceBetweenPoints(LatLng startPosition, LatLng endPosition);
  Future<List> homeChallenges();
}


class ChallengeRepository implements IChallengeRepository{

  @override
  Future<List> getChallenges({required String searchText, required int pageValue, required CancelToken token}) async {

    String requestUrl = sprintf(EndpointConfig.challenges, [MainConfig.main_app_data_count * (pageValue - 1), MainConfig.main_app_data_count, searchText]);
    List listData = await WebService.getCall(url: requestUrl);

    return listData ;
  }

  @override
  Future<List> getChallengeParticipants({required String requestUrl, required CancelToken token}) async {

    List listData = await WebService.getCall(url: requestUrl);
    return listData ;
  }

  @override
  Future<List> getStepBaseStage({required String requestUrl, required CancelToken token}) async {

    List listData = await WebService.getCall(url: requestUrl);
    return listData ;
  }

  @override
  Future<List> joinChallenge({required String requestUrl, required Map<String, dynamic> mapData, required CancelToken token}) async {

    List listData = await WebService.postCall(url: requestUrl,data: mapData,
    );
    return listData ;
  }

  @override
  Future<List> joinStepBaseChallenge({required String requestUrl, required Map<String, dynamic> mapData, required CancelToken token}) async {

    List listData = await WebService.postCall(url: requestUrl,data: mapData,);
    return listData ;

  }
  @override
  Future<List> cancelStepBaseChallenge({required String requestUrl, required Map<String, dynamic> mapData, required CancelToken token}) async {

    List listData = await WebService.postCall(url: requestUrl,data: mapData,);
    return listData ;

  }

  @override
  Future<List> successChallenge({required String requestUrl, required Map<String, dynamic> mapData, required CancelToken token}) async {

    List listData = await WebService.postCall(url: requestUrl,
    data: mapData,
    );
    return listData ;
  }

  @override
  Future<List> cancelChallenge({required String requestUrl, required Map<String, dynamic> mapData, required CancelToken token}) async {

    List listData = await WebService.deleteCall(url: requestUrl,
    data: mapData
    );
    return listData ;
  }

  @override
  Future<List> getAddressInfo({required String requestUrl, required Map<String, dynamic> headers, required CancelToken token}) async {

    List listData = await WebService.getCall(
      url: requestUrl, headers: headers,
    );
    return listData ;
  }

  @override
  Future<List<int>> getDistanceBetweenPoints(LatLng startPosition, LatLng endPosition) async {
    try {
      String reqUrl = sprintf(
          'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${startPosition
              .latitude},${startPosition.longitude}&destinations=${endPosition
              .latitude},${endPosition
              .longitude}&departure_time=now&mode=walking&key=%s',
          [MainConfig.main_map_api_key]);
      final response = await WebService.getCallHttp(
          url: reqUrl
      );
      MapDistanceResponse mapDistanceResponse = MapDistanceResponse.fromJson(response[1]);
      return [
        mapDistanceResponse.rows![0].elements![0].distance!.value!,
        0
        // mapDistanceResponse.rows![0].elements![0].durationInTraffic!.value!,
      ];
    }catch(e){
      return [
        -1,
        -1,
      ];
    }
  }

  @override
  Future<List> homeChallenges() async {
    String requestUrl = HOME_CHALLENGES_URL;
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }


}
