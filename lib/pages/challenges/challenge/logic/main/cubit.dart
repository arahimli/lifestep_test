import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/config/main_config.dart';
import 'package:lifestep/model/challenge/challenge-user.dart';
import 'package:lifestep/model/challenge/challenges.dart';
import 'package:lifestep/model/general/address_info.dart';
import 'package:lifestep/pages/challenges/challenge/logic/main/state.dart';
import 'package:lifestep/repositories/challenge.dart';
import 'package:lifestep/repositories/service/web_service.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:sprintf/sprintf.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';


class MainMapChallengeCubit extends Cubit<MainMapChallengeState> {
  final ChallengeRepository challengeRepository;
  final ChallengeModel challengeModel;
  final ChallengeUserModel challengeUserModel;
  CancelToken dioToken = CancelToken();



  MainMapChallengeCubit({required this.challengeRepository, required this.challengeModel, required this.challengeUserModel}) : super(MainMapChallengeState()) {
  }


  Future<void> initialize() async {

  }

  Future<List> cancelChallenge(int stepGeneral) async {
    return await challengeRepository.cancelChallenge(requestUrl: sprintf(CANCEL_CHALLENGE_URL, [challengeUserModel.id]), mapData: {'steps': stepGeneral}, token: dioToken);
  }

  getAddress() async{

  }

  Future<AddressInfoResponseData> getAddressInfo(LatLng position) async{
    String requestUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude.toString()},${position.longitude.toString()}&key=${MainConfig.main_map_api_key}";
    List listData = await challengeRepository.getAddressInfo(requestUrl: requestUrl, headers: {'Accept': 'application/json'}, token: dioToken);
    if(listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
      return  AddressInfoResponseData.fromJson(listData[2]);
      // title: addressInfoResponseData.results![0].addressComponents![2].longName,
      // address: addressInfoResponseData.results![0].formattedAddress,

    }else{
      throw Exception();
      // emit(AddressInfoError(errorCode: errorCode));
    }
  }

  closeCubit(){
  }

}
