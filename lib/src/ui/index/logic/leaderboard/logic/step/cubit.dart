
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/config/exception.dart';
import 'package:lifestep/src/models/leaderboard/home.dart';
import 'package:lifestep/src/ui/index/logic/leaderboard/logic/step/state.dart';
import 'package:lifestep/src/resources/service/web_service.dart';
import 'package:lifestep/src/resources/step.dart';

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
        emit(const HomeLeaderBoardStepError(errorCode: WEB_SERVICE_ENUM.UNEXCEPTED_ERROR, errorText: "error_went_wrong"));
      }
    }
  }



}