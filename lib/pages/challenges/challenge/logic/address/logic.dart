
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/config/main_config.dart';
import 'package:lifestep/model/challenge/challenge-user.dart';
import 'package:lifestep/model/challenge/challenges.dart';
import 'package:lifestep/model/challenge/map.dart';
import 'package:lifestep/model/general/address_info.dart';
import 'package:lifestep/pages/challenges/challenge/logic/address/state.dart';
import 'package:lifestep/repositories/challenge.dart';
import 'package:lifestep/repositories/service/web_service.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:sprintf/sprintf.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';


class AddressInfoCubit extends Cubit<AddressInfoState> {
  final ChallengeRepository challengeRepository;
  final ChallengeModel challengeModel;
  final ChallengeUserModel challengeUserModel;
  CancelToken dioToken = CancelToken();
  late Timer mainTimer;
  bool mainTimerStopped = false;
  bool mainSecondChanged = false;
  bool addressFetchedOnce = false;
  int completedSecond = 0;
  LatLng? lastCalculatedPosition;
  int distanceMeter = 0;
  final StopWatchTimer stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  AddressInfoCubit({required this.challengeRepository, required this.challengeModel, required this.challengeUserModel}) : super(AddressInfoEmpty(addressText: '')) {
    mainTimer = Timer.periodic(Duration(seconds: 1), timerHandler);

    stopWatchTimer.onExecute.add(StopWatchExecute.start);

    stopWatchTimer.rawTime.listen((value) => secondsChange);
  }

  secondsChange(int value) async {
    // completedSecond = value;
  }

  Future<void> timerHandler(Timer timer) async {
    completedSecond = timer.tick;
    if(timer.tick % 20 == 0){
      if(!mainSecondChanged){
        mainSecondChanged = true;
      }
    }
  }
  Future<void> initialize() async {

  }
  Future<List> cancelChallenge() async {
    return await challengeRepository.cancelChallenge(requestUrl: sprintf(CANCEL_CHALLENGE_URL, [challengeUserModel.id]), mapData: {}, token: dioToken);
  }



  Future<bool> getAddressInfoTimer(LatLng position) async{
    if((mainSecondChanged || !addressFetchedOnce) && !mainTimerStopped){
      if(!addressFetchedOnce){
        emit(AddressInfoLoading());
      }
      getAddressInfo(position);
      return true;
    }else
      return false;
  }
  Future<void> getAddressInfo(LatLng position) async{
    addressFetchedOnce = true;
    String requestUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude.toString()},${position.longitude.toString()}&key=${MainConfig.main_map_api_key}";
    //////// print(requestUrl);
    try {
      List listData = await challengeRepository.getAddressInfo(
          requestUrl: requestUrl,
          headers: {'Accept': 'application/json'},
          token: dioToken);
      mainSecondChanged = false;
      try {
        // emit(AddressInfoLoading());
        if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
          AddressInfoResponseData addressInfoResponseData = AddressInfoResponseData
              .fromJson(listData[1]);
          emit(AddressInfoSuccess(
              addressText: addressInfoResponseData.results![0].formattedAddress,
              point: LatLng(position.latitude, position.longitude), distance: distanceMeter));
            if(lastCalculatedPosition == null){
              lastCalculatedPosition = position;
            }
            //////// print("---------------------------- v1");
          // try{
          //   getDistanceBetweenPoints(lastCalculatedPosition ?? position, position).then((result){
          //     distanceMeter += result[0];
          //     //////// print("getDistanceBetweenPointsgetDistanceBetweenPointsgetDistanceBetweenPoints");
          //     //////// print(result[0]);
          //     lastCalculatedPosition = position;
          //     emit(AddressInfoSuccess(
          //         addressText: addressInfoResponseData.results![0].formattedAddress,
          //         point: LatLng(position.latitude, position.longitude), distance: distanceMeter));
          //
          //   }).catchError((e, stack){
          //     //////// print("getDistanceBetweenPointsgetDistanceBetweenPointsgetDistanceBetweenPoints error");
          //     //////// print(e);
          //     //////// print(stack);
          //   });
          // }catch(e, stack){
          //   //////// print("getDistanceBetweenPointsgetDistanceBetweenPointsgetDistanceBetweenPoints error");
          //   //////// print(e);
          //   //////// print(stack);
          // }
          if(state is AddressInfoSuccess){
            getDistanceBetweenPoints(position, LatLng(challengeModel.endLat!, challengeModel.endLong!))
                .then((val) {
              // _distanceOfTrip=val[0];
              //////// print("checkCompleted____________");
              //////// print(val[0]);
              if(val[0] < challengeModel.endDistance!){

                closeCubit();

                emit(AddressInfoLoading());
                emit(
                    AddressInfoSuccess(
                      addressText: addressInfoResponseData.results![0].formattedAddress,
                      point: LatLng(position.latitude, position.longitude),
                      completed: true,
                      distance: distanceMeter
                    )
                );
              }
            }).catchError((e){

            });
          }
          // title: addressInfoResponseData.results![0].addressComponents![2].longName,
          // address: addressInfoResponseData.results![0].formattedAddress,

        } else {
          // emit(AddressInfoError(errorCode: WEB_SERVICE_ENUM.STANDARD_ERROR));
        }
      } catch (e) {
        // emit(AddressInfoError(errorCode: WEB_SERVICE_ENUM.UNEXCEPTED_ERROR));
      }
    }catch(e){
      mainSecondChanged = false;
    }
  }




  closeCubit(){
    mainTimer.cancel();
    stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    mainTimerStopped = true;
  }

  Future<List<int>> getDistanceBetweenPoints(LatLng startPosition, LatLng endPosition) async {
    // String reqUrl = sprintf('https://maps.googleapis.com/maps/api/distancematrix/json?origins=${startPosition.latitude},${startPosition.longitude}&destinations=${"40.454411"},${"49.738991"}&departure_time=now&key=%s', [MainConfig.main_map_api_key]);
    String reqUrl = sprintf('https://maps.googleapis.com/maps/api/distancematrix/json?origins=${startPosition.latitude},${startPosition.longitude}&destinations=${endPosition.latitude},${endPosition.longitude}&departure_time=now&mode=walking&key=%s', [MainConfig.main_map_api_key]);
    // //////// print(reqUrl);
    final response = await WebService.getCallHttp(
        url:reqUrl
    );
    //////// print(response);
    //////// print(response[1]);
    MapDistanceResponse mapDistanceResponse = MapDistanceResponse.fromJson(response[1]);
    // // //////// print(response[1]['rows'][0]['elements'][0]['duration']['text']);
    // // //////// print(
    // //     "RESPONSE DISTANCE AND TIME ${response[1]['rows'][0]['elements'][0]['duration_in_traffic']['value']}");
    return [
      mapDistanceResponse.rows![0].elements![0].distance!.value!,
      0
      // mapDistanceResponse.rows![0].elements![0].durationInTraffic!.value!,
    ];
  }

  Future<List> successChallenge(int stepCount)async{
    String requestUrl = sprintf(SUCCESS_CHALLENGE_URL, [challengeUserModel.id]);
    return await challengeRepository.successChallenge(
        requestUrl: requestUrl,
        mapData: {
          "success": 1,
          "km":distanceMeter / 1000,
          "time":completedSecond,
          "steps":stepCount,
        },
        token: dioToken
    );
  }


}
