
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/config/exception.dart';
import 'package:lifestep/src/tools/config/main_config.dart';
import 'package:lifestep/src/models/leaderboard/list.dart';
import 'package:lifestep/src/ui/leaderboard/logic/donation/state.dart';
import 'package:lifestep/src/resources/service/web_service.dart';
import 'package:lifestep/src/resources/step.dart';

class LeaderBoardDonationCubit extends  Cubit<LeaderBoardDonationState> {

  final StepRepository stepRepository;
  LeaderBoardDonationCubit({required this.stepRepository}) : super(LeaderBoardDonationLoading()){
    search(reset:true);
    // //////// print("LeaderBoardDonationCubit--------");
  }


  int listCount = MainConfig.main_step_data_count;
  bool isLoading = false;
  String ratingType = "2";
  CancelToken dioToken = CancelToken();
  TextEditingController searchTextController = TextEditingController();

  ScrollController scrollController = ScrollController();
  Future<void> refresh()async{
    await search(reset: true);
  }

  search({bool reset = false}) async {
    var currentState = state;
    if(reset){
      currentState = LeaderBoardDonationLoading();
      emit(LeaderBoardDonationLoading());
      dioToken.cancel();
      dioToken = CancelToken();
    }
    // await Future.delayed(Duration(seconds: 10));
      //////// print(currentState);
    try {
      if (currentState is LeaderBoardDonationLoading) {
        // print('LeaderBoardDonationCubit mapEventToState LeaderBoardDonationLoading listCount: $listCount');
        emit(LeaderBoardDonationLoading());
        List listData = await stepRepository.getStepStatistic(ratingType: ratingType, listCount: listCount, token: dioToken);
        ///////// print("listData__listData__listData__listData__listData__listData__");
        ///////// print(listData);
        if(listData[2] == WEB_SERVICE_ENUM.SUCCESS) {

          UsersRatingResponse usersRatingResponse = UsersRatingResponse.fromJson(listData[1]);
          emit(LeaderBoardDonationSuccess(
              mainData: usersRatingResponse.data!
          ));
          return;
        }else{

          emit(
              LeaderBoardDonationError(
                  errorCode: listData[2],
                  errorText: listData[1]
              )
          );

        }
      }
      if (currentState is LeaderBoardDonationSuccess) {
        if(!isLoading) {
          isLoading = true;
          List listData = await stepRepository.getStepStatistic(ratingType: ratingType, listCount: listCount, token: dioToken);
          isLoading = false;
          if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {

            UsersRatingResponse usersRatingResponse = UsersRatingResponse.fromJson(listData[1]);
            emit(LeaderBoardDonationSuccess(
                mainData: usersRatingResponse.data!
            ));
            return;
          }else if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH){
            emit( LeaderBoardDonationError(errorCode: listData[2], errorText: listData[1]));
          }
        }
      }
    } catch (exception) {
      if (exception is HTTPException) {
        emit(const LeaderBoardDonationError(errorCode: WEB_SERVICE_ENUM.UNEXCEPTED_ERROR, errorText: "error_went_wrong"));
      }
    }
  }



}