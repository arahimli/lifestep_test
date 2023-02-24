
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/data/models/challenge/inner.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/tools/config/endpoint_config.dart';
import 'package:lifestep/features/main_app/data/models/challenge/challenges.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/details/logic/details_state.dart';
import 'package:lifestep/features/main_app/resources/challenge.dart';
import 'package:sprintf/sprintf.dart';

class ChallengeDetailBloc extends  Cubit<ChallengeDetailState> {
  
  final IChallengeRepository challengeRepository;
  final ChallengeModel challengeModel;
  ChallengeDetailBloc({required this.challengeModel, required this.challengeRepository}) : super(ChallengeDetailState(challengeModel: challengeModel, hashCodeData: Utils.generateRandomString(10)));


  bool isLoading = false;
  String searchText = "";
  CancelToken dioToken = CancelToken();

  ScrollController scrollController = ScrollController();

  Future<List> handleChallenge() async{
    String requestUrl = sprintf(EndpointConfig.joinChallenge, []);

    List listData = await challengeRepository.joinChallenge(
        requestUrl: requestUrl, mapData: {"challenge_id": challengeModel.id}, token: dioToken);
    return listData;
  }
  setCharity(ChallengeModel challengeModel) async{
    //////// print("setCharity________________________________________");
    challengeChanged = true;
    emit(state.copyWith(challengeModel: challengeModel));
  }

  bool challengeChanged = false;

  Future<List> joinStepBaseChallenge() async{
    String requestUrl = sprintf(EndpointConfig.joinStepBaseChallenge, [challengeModel.id]);

    List listData = await challengeRepository.joinStepBaseChallenge(
        requestUrl: requestUrl, mapData: {"challenge_id": challengeModel.id}, token: dioToken);
    log("[LOG joinStepBaseChallenge]" + listData[2].toString());
    if(listData[2] == WEB_SERVICE_ENUM.success) {
      StepBaseStageResponse stepBaseStageResponse = StepBaseStageResponse.fromJson(listData[1]);

      log("[LOG joinStepBaseChallenge] listData[2].toString()");
      challengeChanged = true;
      emit(state.copyWith(challengeModel: stepBaseStageResponse.data!.challenge!));

    }
    return listData;
  }

  Future<List> cancelStepBaseChallenge() async{
    String requestUrl = sprintf(EndpointConfig.cancelStepBaseChallenge, [challengeModel.id]);

    List listData = await challengeRepository.cancelStepBaseChallenge(
        requestUrl: requestUrl, mapData: {"challenge_id": challengeModel.id}, token: dioToken);
    log("[LOG cancelStepBaseChallenge]" + listData[2].toString());
    if(listData[2] == WEB_SERVICE_ENUM.success) {
      StepBaseStageResponse stepBaseStageResponse = StepBaseStageResponse.fromJson(listData[1]);

      challengeChanged = true;
      emit(state.copyWith(challengeModel: stepBaseStageResponse.data!.challenge!));

    }
    return listData;
  }
}