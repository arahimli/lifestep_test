import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lifestep/features/tools/config/endpoint_config.dart';
import 'package:lifestep/features/tools/config/main_config.dart';
import 'package:lifestep/features/main_app/data/models/challenge/challenge_user.dart';
import 'package:lifestep/features/main_app/data/models/challenge/challenges.dart';
import 'package:lifestep/features/main_app/data/models/general/address_info.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/challenge/logic/main/state.dart';
import 'package:lifestep/features/main_app/resources/challenge.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:sprintf/sprintf.dart';


class MainMapChallengeCubit extends Cubit<MainMapChallengeState> {
  final IChallengeRepository challengeRepository;
  final ChallengeModel challengeModel;
  final ChallengeUserModel challengeUserModel;
  CancelToken dioToken = CancelToken();



  MainMapChallengeCubit({required this.challengeRepository, required this.challengeModel, required this.challengeUserModel}) : super(MainMapChallengeState());


  Future<void> initialize() async {

  }

  Future<List> cancelChallenge(int stepGeneral) async {
    return await challengeRepository.cancelChallenge(requestUrl: sprintf(EndpointConfig.cancelChallenge, [challengeUserModel.id]), mapData: {'steps': stepGeneral}, token: dioToken);
  }

  getAddress() async{

  }

  Future<AddressInfoResponseData> getAddressInfo(LatLng position) async{
    String requestUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude.toString()},${position.longitude.toString()}&key=${MainConfig.mainMapApiKey}";
    List listData = await challengeRepository.getAddressInfo(requestUrl: requestUrl, headers: {'Accept': 'application/json'}, token: dioToken);
    if(listData[2] == WEB_SERVICE_ENUM.success) {
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
