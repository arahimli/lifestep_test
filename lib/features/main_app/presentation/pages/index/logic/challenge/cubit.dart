
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/data/models/challenge/challenges.dart';
import 'package:lifestep/features/main_app/data/models/home/challenge_list.dart';
import 'package:lifestep/features/main_app/resources/challenge.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/tools/config/exception.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/challenge/state.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';

class HomeChallengeListCubit extends  Cubit<HomeChallengeListState> {

  final IChallengeRepository challengeRepository;
  HomeChallengeListCubit({required this.challengeRepository}) : super(HomeChallengeListLoading()){
    search();
  }


  bool isLoading = false;
  CancelToken dioToken = CancelToken();

  ScrollController scrollController = ScrollController();
  Future<void> refresh()async{
    await search(reset: true);
  }

  search({bool reset = false}) async {
    var currentState = state;
    if(reset){
      currentState = HomeChallengeListLoading();
      emit(HomeChallengeListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
    }
    // await Future.delayed( const Duration(seconds: 10));
    try {
      if (currentState is HomeChallengeListLoading) {
        emit(HomeChallengeListFetching());
        List listData = await challengeRepository.homeChallenges();
        if(listData[2] == WEB_SERVICE_ENUM.success) {
          HomeChallengeListResponse homeChallengeListResponse = HomeChallengeListResponse.fromJson(listData[1]);
          emit(HomeChallengeListSuccess(
            dataList: homeChallengeListResponse.data!.challenges ?? [],
            stepInnerList: homeChallengeListResponse.data!.stepInner ?? [],
            hash: Utils.generateRandomString(10)
          ));
          return;
        }else{

          emit(
              HomeChallengeListError(
                errorCode: listData[2],
                errorText: listData[1],
              )
          );

        }
      }
      if (currentState is HomeChallengeListSuccess) {
        if(!isLoading) {
          isLoading = true;
          List listData = await challengeRepository.homeChallenges();
          isLoading = false;
          if (listData[2] == WEB_SERVICE_ENUM.success) {

            HomeChallengeListResponse homeChallengeListResponse = HomeChallengeListResponse.fromJson(listData[1]);
            emit(HomeChallengeListSuccess(
                dataList: homeChallengeListResponse.data!.challenges ?? [],
                stepInnerList: homeChallengeListResponse.data!.stepInner ?? [],
                hash: Utils.generateRandomString(10)
            ));
            return;
          }else if (listData[2] == WEB_SERVICE_ENUM.unAuth){
            emit( HomeChallengeListError(errorCode: listData[2], errorText: listData[1]));
          }
        }
      }
    } catch (exception) {
      if (exception is HTTPException) {
        emit(const HomeChallengeListError(errorCode: WEB_SERVICE_ENUM.unexpectedError, errorText: "error_went_wrong"));
      }
    }
  }





  changeChallenge({required List<ChallengeModel> listValue, required List<StepInnerModel> listStepInnerModel, required bool boolValue, required ChallengeModel value, required int index}) async {
    List<ChallengeModel> returnValue = listValue;
    returnValue[index] = value;

      emit(HomeChallengeListSuccess(
          dataList: returnValue,
          stepInnerList: listStepInnerModel,
          hash: Utils.generateRandomString(10)
      ));
  }
}