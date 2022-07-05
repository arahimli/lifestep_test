
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/config/exception.dart';
import 'package:lifestep/config/main_config.dart';
import 'package:lifestep/model/challenge/challenges.dart';
import 'package:lifestep/model/donation/charities.dart';
import 'package:lifestep/model/leaderboard/list.dart';
import 'package:lifestep/pages/challenges/list/logic/state.dart';
import 'package:lifestep/pages/donations/list/logic/charity_state.dart';
import 'package:lifestep/pages/leaderboard/logic/step/state.dart';
import 'package:lifestep/repositories/challenge.dart';
import 'package:lifestep/repositories/donation.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:lifestep/repositories/step.dart';

class LeaderBoardStepCubit extends  Cubit<LeaderBoardStepState> {

  final StepRepository stepRepository;
  LeaderBoardStepCubit({required this.stepRepository}) : assert(stepRepository != null), super(LeaderBoardStepLoading()){
    this.search(reset:true);
    // //////// print("LeaderBoardStepCubit--------");
  }


  int listCount = MainConfig.main_step_data_count;
  bool isLoading = false;
  String ratingType = "1";
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
      currentState = LeaderBoardStepLoading();
      emit(LeaderBoardStepLoading());
      dioToken.cancel();
      dioToken = CancelToken();
    }
    // await Future.delayed(Duration(seconds: 10));
      //////// print(currentState);
    try {
      if (currentState is LeaderBoardStepLoading) {
        // print('LeaderBoardStepCubit mapEventToState LeaderBoardStepLoading listCount: $listCount');
        emit(LeaderBoardStepLoading());
        List listData = await stepRepository.getStepStatistic(ratingType: ratingType, listCount: listCount, token: dioToken);
        ///////// print("listData__listData__listData__listData__listData__listData__");
        ///////// print(listData);
        if(listData[2] == WEB_SERVICE_ENUM.SUCCESS) {

          UsersRatingResponse usersRatingResponse = UsersRatingResponse.fromJson(listData[1]);
          emit(LeaderBoardStepSuccess(
              mainData: usersRatingResponse.data!
          ));
          return;
        }else{

          emit(
              LeaderBoardStepError(
                  errorCode: listData[2],
                  errorText: listData[1]
              )
          );

        }
      }
      if (currentState is LeaderBoardStepSuccess) {
        if(!isLoading) {
          isLoading = true;
          List listData = await stepRepository.getStepStatistic(ratingType: ratingType, listCount: listCount, token: dioToken);
          isLoading = false;
          if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {

            UsersRatingResponse usersRatingResponse = UsersRatingResponse.fromJson(listData[1]);
            emit(LeaderBoardStepSuccess(
                mainData: usersRatingResponse.data!
            ));
            return;
          }else if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH){
            emit( LeaderBoardStepError(errorCode: listData[2], errorText: listData[1]));
          }
        }
      }
    } catch (exception) {
      if (exception is HTTPException) {
        emit(LeaderBoardStepError(errorCode: WEB_SERVICE_ENUM.UNEXCEPTED_ERROR, errorText: "error_went_wrong"));
      }
    }
  }



}