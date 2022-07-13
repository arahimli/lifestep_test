
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/config/exception.dart';
import 'package:lifestep/config/main_config.dart';
import 'package:lifestep/model/challenge/challenges.dart';
import 'package:lifestep/model/donation/charities.dart';
import 'package:lifestep/model/leaderboard/home.dart';
import 'package:lifestep/model/leaderboard/list.dart';
import 'package:lifestep/pages/challenges/list/logic/state.dart';
import 'package:lifestep/pages/donations/list/logic/charity_state.dart';
import 'package:lifestep/pages/index/logic/leaderboard/logic/step/state.dart';
import 'package:lifestep/pages/leaderboard/logic/step/state.dart';
import 'package:lifestep/repositories/challenge.dart';
import 'package:lifestep/repositories/donation.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:lifestep/repositories/step.dart';

class HomeLeaderBoardStepCubit extends  Cubit<HomeLeaderBoardStepState> {

  final StepRepository stepRepository;
  HomeLeaderBoardStepCubit({required this.stepRepository}) : assert(stepRepository != null), super(HomeLeaderBoardStepLoading()){
    this.search(reset:true);
    // //////// print("HomeLeaderBoardStepCubit--------");
  }


  int listCount = 5;
  bool isLoading = false;
  String ratingType = "1";
  int dateType = 2;
  CancelToken dioToken = CancelToken();
  TextEditingController searchTextController = TextEditingController();

  ScrollController scrollController = ScrollController();
  Future<void> refresh()async{
    await search(reset: true);
  }
  @override
  search({bool reset:false}) async {
    var currentState = state;

   ///////// print("HomeLeaderBoardStepCubit__HomeLeaderBoardStepCubit__HomeLeaderBoardStepCubit");
    if(reset){
      currentState = HomeLeaderBoardStepLoading();
      emit(HomeLeaderBoardStepLoading());
      dioToken.cancel();
      dioToken = CancelToken();
    }
   ///////// print("HomeLeaderBoardStepCubit__HomeLeaderBoardStepCubit__HomeLeaderBoardStepCubit");
    // await Future.delayed(Duration(seconds: 10));
      //////// print(currentState);
    try {
      if (currentState is HomeLeaderBoardStepLoading) {
        // print('HomeLeaderBoardStepCubit mapEventToState HomeLeaderBoardStepLoading listCount: $listCount');
        emit(HomeLeaderBoardStepLoading());
        // await Future.delayed(Duration(seconds: 10));
        List listData = await stepRepository.getStepStatisticByDate(ratingType: ratingType, listCount: listCount, dateType: dateType, token: dioToken);
        ///////// print("listData__listData__listData__listData__listData__listData__");
        ///////// print(listData);
        if(listData[2] == WEB_SERVICE_ENUM.SUCCESS) {

          HomeLeaderBoardResponse homeLeaderBoardResponse = HomeLeaderBoardResponse.fromJson(listData[1]);
          emit(HomeLeaderBoardStepSuccess(
              mainData: homeLeaderBoardResponse.data!
          ));
          return;
        }else{

          emit(
              HomeLeaderBoardStepError(
                  errorCode: listData[2],
                  errorText: listData[1]
              )
          );

        }
      }
      if (currentState is HomeLeaderBoardStepSuccess) {
        if(!isLoading) {
          isLoading = true;
          List listData = await stepRepository.getStepStatisticByDate(ratingType: ratingType, listCount: listCount, dateType: dateType, token: dioToken);
          isLoading = false;
          if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {

            HomeLeaderBoardResponse homeLeaderBoardResponse = HomeLeaderBoardResponse.fromJson(listData[1]);
            emit(HomeLeaderBoardStepSuccess(
                mainData: homeLeaderBoardResponse.data!
            ));
            return;
          }else if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH){
            emit( HomeLeaderBoardStepError(errorCode: listData[2], errorText: listData[1]));
          }
        }
      }
    } catch (exception) {
      if (exception is HTTPException) {
        emit(HomeLeaderBoardStepError(errorCode: WEB_SERVICE_ENUM.UNEXCEPTED_ERROR, errorText: "error_went_wrong"));
      }
    }
  }



}