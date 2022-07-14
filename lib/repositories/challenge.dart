import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/config/main_config.dart';
import 'package:lifestep/model/challenge/map.dart';
import 'package:lifestep/model/donation/search_configuration.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:lifestep/tools/constants/header/auth.dart';
import 'package:sprintf/sprintf.dart';

class ChallengeRepository {

  final donationProvider = ChallengeProvider();

  Future<List> getChallenges({required String searchText, required int pageValue, required CancelToken token}) => donationProvider.getChallenges(searchText, pageValue, token);
  Future<List> getChallengeParticipants({required String requestUrl, required CancelToken token}) => donationProvider.getChallengeParticipants(requestUrl, token);
  Future<List> joinChallenge({required String requestUrl, required Map<String, dynamic> mapData, required CancelToken token}) => donationProvider.joinChallenge(requestUrl, mapData, token);
  Future<List> successChallenge({required String requestUrl, required Map<String, dynamic> mapData, required CancelToken token}) => donationProvider.successChallenge(requestUrl, mapData, token);
  Future<List> cancelChallenge({required String requestUrl, required Map<String, dynamic> mapData, required CancelToken token}) => donationProvider.cancelChallenge(requestUrl, mapData, token);
  Future<List> getAddressInfo({required String requestUrl, required Map<String, dynamic> headers, required CancelToken token}) => donationProvider.getAddressInfo(requestUrl, headers, token);
  Future<List<int>> getDistanceBetweenPoints(LatLng startPosition, LatLng endPosition) => donationProvider.getDistanceBetweenPoints(startPosition, endPosition);

}


class ChallengeProvider {

  Future<List> getChallenges(String searchText, int pageValue, CancelToken token) async {

    String requestUrl = sprintf(CHALLENGES_URL, [MainConfig.main_app_data_count * (pageValue - 1), MainConfig.main_app_data_count, searchText]);
    List data = await WebService.getCall(url: requestUrl);
    return data;
  }
  
  Future<List> getChallengeParticipants(String requestUrl, CancelToken token) async {

    List data = await WebService.getCall(url: requestUrl);
    return data;
  }

  Future<List> joinChallenge(String requestUrl, Map<String, dynamic> mapData, CancelToken token) async {

    List data = await WebService.postCall(url: requestUrl,data: mapData,
    );
    return data;
  }

  Future<List> successChallenge(String requestUrl, Map<String, dynamic> mapData, CancelToken token) async {

    List data = await WebService.postCall(url: requestUrl,
    data: mapData,
    );
    return data;
  }

  Future<List> cancelChallenge(String requestUrl, Map<String, dynamic> mapData, CancelToken token) async {

    List data = await WebService.deleteCall(url: requestUrl,
    data: mapData
    );
    return data;
  }

  Future<List> getAddressInfo(String requestUrl, Map<String, dynamic> headers, CancelToken token) async {

    List data = await WebService.getCall(
      url: requestUrl, headers: headers,
    );
    return data;
  }


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


}
