
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/tools/config/endpoint_config.dart';
import 'package:lifestep/features/tools/config/exception.dart';
import 'package:lifestep/features/main_app/data/models/challenge/challenges.dart';
import 'package:lifestep/features/main_app/data/models/challenge/participants.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/details/logic/participants/state.dart';
import 'package:lifestep/features/main_app/resources/challenge.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:sprintf/sprintf.dart';

class ParticipantListCubit extends Cubit<ParticipantListState> {

  final IChallengeRepository challengeRepository;
  final ChallengeModel challengeModel;
  ParticipantListCubit({required this.challengeRepository, required this.challengeModel}) :
        // assert(challengeRepository != null),
        super(ParticipantListLoading()){
    search();
  }

  bool isLoading = false;
  CancelToken dioToken = CancelToken();


  search({bool reset= true}) async {
    var currentState = state;
    if(reset){
      currentState = ParticipantListLoading();
      emit(ParticipantListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
    }
    String requestUrl = sprintf(EndpointConfig.challengeUsers, [challengeModel.id]);
      try {
        if (currentState is ParticipantListLoading) {
          emit(ParticipantListFetching());
          List listData = await challengeRepository.getChallengeParticipants(requestUrl: requestUrl, token: dioToken);
          if(listData[2] == WEB_SERVICE_ENUM.success) {
            ParticipantListResponse fondListResponse = ParticipantListResponse.fromJson(listData[1]);

            emit(ParticipantListSuccess(dataList: fondListResponse.data!.users ?? [], dataCount: fondListResponse.data!.count ?? 0));
            return;
          }else{

            emit(
                ParticipantListError(
                  errorCode: listData[2],
                )
            );

          }
        }
        if (currentState is ParticipantListSuccess) {
          if(!isLoading) {
            isLoading = true;
            List listData = await challengeRepository.getChallengeParticipants(
                requestUrl: requestUrl, token: dioToken);
            isLoading = false;

            if (listData[2] == WEB_SERVICE_ENUM.success) {

              ParticipantListResponse fondListResponse = ParticipantListResponse.fromJson(listData[1]);
              emit(ParticipantListSuccess(dataList: fondListResponse.data!.users ?? [], dataCount: fondListResponse.data!.count ?? 0));
              return;
            }else if (listData[2] == WEB_SERVICE_ENUM.unAuth){
              emit(ParticipantListError(errorCode: listData[2]));
            }
          }
        }
      } catch (exception) {
        if (exception is HTTPException) {
          emit(const ParticipantListError(errorCode: WEB_SERVICE_ENUM.unexpectedError));
        }
      }
  }

  setParticipants(List<ParticipantModel> value, int count)async{
    emit(ParticipantListSuccess(dataList: value, dataCount: count));
  }
}