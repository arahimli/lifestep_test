
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
import 'package:lifestep/pages/index/index/logic/leaderboard/logic/donation/state.dart';
import 'package:lifestep/pages/leaderboard/logic/donation/state.dart';
import 'package:lifestep/pages/leaderboard/logic/step/state.dart';
import 'package:lifestep/repositories/challenge.dart';
import 'package:lifestep/repositories/donation.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:lifestep/repositories/step.dart';

class HomeLeaderBoardDonationCubit extends  Cubit<HomeLeaderBoardDonationState> {

  final StepRepository stepRepository;
  HomeLeaderBoardDonationCubit({required this.stepRepository}) : assert(stepRepository != null), super(HomeLeaderBoardDonationLoading()){
    this.search(reset:true);
    // //////// print("HomeLeaderBoardDonationCubit--------");
  }


  int listCount = 5;
  bool isLoading = false;
  String ratingType = "2";
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
    if(reset){
      currentState = HomeLeaderBoardDonationLoading();
      emit(HomeLeaderBoardDonationLoading());
      dioToken.cancel();
      dioToken = CancelToken();
    }
    // await Future.delayed(Duration(seconds: 10));
      //////// print(currentState);
    try {
      if (currentState is HomeLeaderBoardDonationLoading) {
        // print('HomeLeaderBoardDonationCubit mapEventToState HomeLeaderBoardDonationLoading listCount: $listCount');
        emit(HomeLeaderBoardDonationLoading());
        List listData = await stepRepository.getStepStatisticByDate(ratingType: ratingType, listCount: listCount, dateType: dateType, token: dioToken);
        ///////// print("listData__listData__listData__listData__listData__listData__");
        ///////// print(listData);
        if(listData[2] == WEB_SERVICE_ENUM.SUCCESS) {

          HomeLeaderBoardResponse homeLeaderBoardResponse = HomeLeaderBoardResponse.fromJson(listData[1]);
          emit(HomeLeaderBoardDonationSuccess(
              mainData: homeLeaderBoardResponse.data!
          ));
          return;
        }else{

          emit(
              HomeLeaderBoardDonationError(
                  errorCode: listData[2],
                  errorText: listData[1]
              )
          );

        }
      }
      if (currentState is HomeLeaderBoardDonationSuccess) {
        if(!isLoading) {
          isLoading = true;
          List listData = await stepRepository.getStepStatisticByDate(ratingType: ratingType, listCount: listCount, dateType: dateType, token: dioToken);
          isLoading = false;
          if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {

            HomeLeaderBoardResponse homeLeaderBoardResponse = HomeLeaderBoardResponse.fromJson(listData[1]);
            emit(HomeLeaderBoardDonationSuccess(
                mainData: homeLeaderBoardResponse.data!
            ));
            return;
          }else if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH){
            emit( HomeLeaderBoardDonationError(errorCode: listData[2], errorText: listData[1]));
          }
        }
      }
    } catch (exception) {
      if (exception is HTTPException) {
        emit(HomeLeaderBoardDonationError(errorCode: WEB_SERVICE_ENUM.UNEXCEPTED_ERROR, errorText: "error_went_wrong"));
      }
    }
  }



}