
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/tools/config/exception.dart';
import 'package:lifestep/features/main_app/data/models/step/user_order.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:lifestep/features/main_app/resources/step.dart';

import 'state.dart';

class GeneralUserLeaderBoardWeekDonationCubit extends  Cubit<GeneralUserLeaderBoardWeekDonationState> {

  final StepRepository stepRepository;
  GeneralUserLeaderBoardWeekDonationCubit({required this.stepRepository}) :
        // assert(stepRepository != null),
        super(GeneralUserLeaderBoardWeekDonationLoading()){
    search(reset:true);
  }


  bool isLoading = false;
  String raitingType = "2";
  String rangeType = "1";
  CancelToken dioToken = CancelToken();
  TextEditingController searchTextController = TextEditingController();

  ScrollController scrollController = ScrollController();
  Future<void> refresh()async{
    await search(reset: true);
  }

  search({bool reset = false}) async {
    var currentState = state;
    if(reset){
      currentState = GeneralUserLeaderBoardWeekDonationLoading();
      emit(GeneralUserLeaderBoardWeekDonationLoading());
      dioToken.cancel();
      dioToken = CancelToken();
    }

    try {
      if (currentState is GeneralUserLeaderBoardWeekDonationLoading) {
        emit(GeneralUserLeaderBoardWeekDonationLoading());
        List listData = await stepRepository.getUserOrderRatingStepStatistic(raitingType: raitingType, rangeType: rangeType, token: dioToken);
        if(listData[2] == WEB_SERVICE_ENUM.success) {

          UserOrderResponse userOrderResponse = UserOrderResponse.fromJson(listData[1]);
          emit(GeneralUserLeaderBoardWeekDonationSuccess(
              mainData: userOrderResponse.data!
          ));
          return;
        }else{
          emit(
              GeneralUserLeaderBoardWeekDonationError(
                  errorCode: listData[2],
                  errorText: listData[1]
              )
          );

        }
      }
      if (currentState is GeneralUserLeaderBoardWeekDonationSuccess) {
        if(!isLoading) {
          isLoading = true;
          List listData = await stepRepository.getUserOrderRatingStepStatistic(raitingType: raitingType, rangeType: rangeType, token: dioToken);
          isLoading = false;
          if (listData[2] == WEB_SERVICE_ENUM.success) {

            UserOrderResponse userOrderResponse = UserOrderResponse.fromJson(listData[1]);
            emit(GeneralUserLeaderBoardWeekDonationSuccess(
                mainData: userOrderResponse.data!
            ));
            return;
          }
        }
      }
    } catch (exception) {
      if (exception is HTTPException) {
        emit(const GeneralUserLeaderBoardWeekDonationError(errorCode: WEB_SERVICE_ENUM.unexpectedError, errorText: "error_went_wrong"));
      }
    }

  }
}