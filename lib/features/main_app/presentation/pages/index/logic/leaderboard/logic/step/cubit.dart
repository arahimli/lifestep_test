
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/tools/config/exception.dart';
import 'package:lifestep/features/main_app/data/models/leaderboard/home.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/leaderboard/logic/step/state.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:lifestep/features/main_app/resources/step.dart';

class HomeLeaderBoardStepCubit extends  Cubit<HomeLeaderBoardStepState> {

  final StepRepository stepRepository;
  HomeLeaderBoardStepCubit({required this.stepRepository}) : super(HomeLeaderBoardStepLoading()){
    search(reset:true);
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

  search({bool reset = false}) async {
    var currentState = state;

   ///////// print("HomeLeaderBoardStepCubit__HomeLeaderBoardStepCubit__HomeLeaderBoardStepCubit");
    if(reset){
      currentState = HomeLeaderBoardStepLoading();
      emit(HomeLeaderBoardStepLoading());
      dioToken.cancel();
      dioToken = CancelToken();
    }
    // await Future.delayed( const Duration(seconds: 10));
    try {
      if (currentState is HomeLeaderBoardStepLoading) {
        emit(HomeLeaderBoardStepLoading());
        List listData = await stepRepository.getStepStatisticByDate(ratingType: ratingType, listCount: listCount, dateType: dateType, token: dioToken);
        if(listData[2] == WEB_SERVICE_ENUM.success) {

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
          if (listData[2] == WEB_SERVICE_ENUM.success) {

            HomeLeaderBoardResponse homeLeaderBoardResponse = HomeLeaderBoardResponse.fromJson(listData[1]);
            emit(HomeLeaderBoardStepSuccess(
                mainData: homeLeaderBoardResponse.data!
            ));
            return;
          }else if (listData[2] == WEB_SERVICE_ENUM.unAuth){
            emit( HomeLeaderBoardStepError(errorCode: listData[2], errorText: listData[1]));
          }
        }
      }
    } catch (exception) {
      if (exception is HTTPException) {
        emit(const HomeLeaderBoardStepError(errorCode: WEB_SERVICE_ENUM.unexpectedError, errorText: "error_went_wrong"));
      }
    }
  }



}