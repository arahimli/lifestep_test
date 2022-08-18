
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/config/endpoint_config.dart';
import 'package:lifestep/src/models/challenge/challenges.dart';
import 'package:lifestep/src/ui/challenges/details/logic/details_state.dart';
import 'package:lifestep/src/resources/challenge.dart';
import 'package:sprintf/sprintf.dart';

class ChallengeDetailBloc extends  Cubit<ChallengeDetailState> {
  
  final ChallengeRepository challengeRepository;
  final ChallengeModel challengeModel;
  ChallengeDetailBloc({required this.challengeModel, required this.challengeRepository}) : assert(challengeRepository != null), super(ChallengeDetailState(challengeModel: challengeModel));


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
}