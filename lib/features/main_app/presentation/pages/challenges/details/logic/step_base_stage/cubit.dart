
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/data/models/challenge/inner.dart';
import 'package:lifestep/features/tools/config/endpoint_config.dart';
import 'package:lifestep/features/tools/config/exception.dart';
import 'package:lifestep/features/main_app/data/models/challenge/challenges.dart';
import 'package:lifestep/features/main_app/resources/challenge.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/details/logic/step_base_stage/state.dart';
import 'package:sprintf/sprintf.dart';

class StepBaseStageCubit extends Cubit<StepBaseStageState> {

  final IChallengeRepository challengeRepository;
  final ChallengeModel challengeModel;
  StepBaseStageCubit({required this.challengeRepository, required this.challengeModel}) : /* assert(challengeRepository != null), */ super(StepBaseStageLoading()){
    search();
  }

  bool isLoading = false;
  CancelToken dioToken = CancelToken();


  search({bool reset= true}) async {
    var currentState = state;
    if(reset){
      currentState = StepBaseStageLoading();
      emit(StepBaseStageLoading());
      dioToken.cancel();
      dioToken = CancelToken();
    }
    String requestUrl = sprintf(EndpointConfig.challengeStepBaseStage, [challengeModel.id]);
      try {
        if (currentState is StepBaseStageLoading) {
          emit(StepBaseStageFetching());
          List listData = await challengeRepository.getStepBaseStage(requestUrl: requestUrl, token: dioToken);
          if(listData[2] == WEB_SERVICE_ENUM.success) {
            StepBaseStageResponse stepBaseStageResponse = StepBaseStageResponse.fromJson(listData[1]);

            emit(StepBaseStageSuccess(challengeLevels: stepBaseStageResponse.data!.challengeLevels ?? [], userSteps: stepBaseStageResponse.data!.userSteps ?? 0, challenge: stepBaseStageResponse.data!.challenge!));
            return;
          }else{

            emit(
                StepBaseStageError(
                  errorCode: listData[2],
                )
            );

          }
        }
        if (currentState is StepBaseStageSuccess) {
          if(!isLoading) {
            isLoading = true;
            List listData = await challengeRepository.getChallengeParticipants(
                requestUrl: requestUrl, token: dioToken);
            isLoading = false;

            if (listData[2] == WEB_SERVICE_ENUM.success) {
              StepBaseStageResponse stepBaseStageResponse = StepBaseStageResponse.fromJson(listData[1]);
              emit(StepBaseStageSuccess(challengeLevels: stepBaseStageResponse.data!.challengeLevels ?? [], userSteps: stepBaseStageResponse.data!.userSteps ?? 0, challenge: stepBaseStageResponse.data!.challenge!));
              return;
            }else if (listData[2] == WEB_SERVICE_ENUM.unAuth){
              emit(StepBaseStageError(errorCode: listData[2]));
            }
          }
        }
      } catch (exception) {
        if (exception is HTTPException) {
          emit(const StepBaseStageError(errorCode: WEB_SERVICE_ENUM.unexpectedError));
        }
      }
  }

  setParticipants(List<ChallengeLevelModel> value, int count, ChallengeModel challenge)async{
    emit(StepBaseStageSuccess(challengeLevels: value, userSteps: count, challenge: challenge));
  }
}