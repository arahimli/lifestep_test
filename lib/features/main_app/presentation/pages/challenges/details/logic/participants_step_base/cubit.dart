
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/data/models/challenge/participants_step_base.dart';
import 'package:lifestep/features/tools/common/utlis.dart';
import 'package:lifestep/features/tools/config/endpoint_config.dart';
import 'package:lifestep/features/tools/config/exception.dart';
import 'package:lifestep/features/main_app/data/models/challenge/challenges.dart';
import 'package:lifestep/features/main_app/resources/challenge.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:sprintf/sprintf.dart';

import 'state.dart';

class StepBaseParticipantListCubit extends Cubit<StepBaseParticipantListState> {

  final IChallengeRepository challengeRepository;
  final ChallengeModel challengeModel;
  StepBaseParticipantListCubit({required this.challengeRepository, required this.challengeModel}) : super(StepBaseParticipantListLoading()){
    search();
    // //////// print("StepBaseParticipantListCubit--------");
  }

  bool isLoading = false;
  CancelToken dioToken = CancelToken();


  search({bool reset= true}) async {
    var currentState = state;
    if(reset){
      currentState = StepBaseParticipantListLoading();
      emit(StepBaseParticipantListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
    }
    String requestUrl = sprintf(EndpointConfig.challengeStepBaseUsers, [challengeModel.id, 7]);
      try {
        if (currentState is StepBaseParticipantListLoading) {
          emit(StepBaseParticipantListFetching());
          List listData = await challengeRepository.getChallengeParticipants(requestUrl: requestUrl, token: dioToken);
          if(listData[2] == WEB_SERVICE_ENUM.success) {
            StepBaseParticipantListResponse dataListResponse = StepBaseParticipantListResponse.fromJson(listData[1]);

            emit(StepBaseParticipantListSuccess(dataList: dataListResponse.data ?? [], hash: Utils.generateRandomString(10)));
            return;
          }else{

            emit(
                StepBaseParticipantListError(
                  errorCode: listData[2],
                )
            );

          }
        }
        if (currentState is StepBaseParticipantListSuccess) {
          if(!isLoading) {
            isLoading = true;
            List listData = await challengeRepository.getChallengeParticipants(
                requestUrl: requestUrl, token: dioToken);
            isLoading = false;

            //////// print("dataListResponse.data listData[2]");
            //////// print(listData[2]);
            if (listData[2] == WEB_SERVICE_ENUM.success) {

              //////// print("dataListResponse.data");
              StepBaseParticipantListResponse dataListResponse = StepBaseParticipantListResponse.fromJson(listData[1]);
              //////// print("dataListResponse.data");
              //////// print(dataListResponse.data);
              // emit(StepBaseParticipantListLoading());
              emit(StepBaseParticipantListSuccess(dataList: dataListResponse.data ?? [], hash: Utils.generateRandomString(10)));
              return;
            }else if (listData[2] == WEB_SERVICE_ENUM.unAuth){
              emit(StepBaseParticipantListError(errorCode: listData[2]));
            }
          }
        }
      } catch (exception) {
        //////// print('StepBaseParticipantListCubit mapEventToState exception: $exception');
        if (exception is HTTPException) {
          emit(const StepBaseParticipantListError(errorCode: WEB_SERVICE_ENUM.unexpectedError));
        }
      }
  }

  setParticipants(List<StepBaseParticipantModel> value, int count)async{
    //////// print("setParticipants________________________________________");
    emit(StepBaseParticipantListSuccess(dataList: value, hash: Utils.generateRandomString(10)));
  }
}