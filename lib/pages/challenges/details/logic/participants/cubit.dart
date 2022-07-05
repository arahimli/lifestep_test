
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/config/exception.dart';
import 'package:lifestep/model/challenge/challenges.dart';
import 'package:lifestep/model/challenge/participants.dart';
import 'package:lifestep/model/donation/fonds.dart';
import 'package:lifestep/pages/challenges/details/logic/participants/state.dart';
import 'package:lifestep/repositories/challenge.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:sprintf/sprintf.dart';

class ParticipantListCubit extends Cubit<ParticipantListState> {

  final ChallengeRepository challengeRepository;
  final ChallengeModel challengeModel;
  ParticipantListCubit({required this.challengeRepository, required this.challengeModel}) : assert(challengeRepository != null), super(ParticipantListLoading()){
    this.search();
    // //////// print("ParticipantListCubit--------");
  }

  bool isLoading = false;
  CancelToken dioToken = CancelToken();


  search({bool reset: true}) async {
    var currentState = state;
    if(reset){
      currentState = ParticipantListLoading();
      emit(ParticipantListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
    }
    String requestUrl = sprintf(CHALLENGE_USERS_URL, [challengeModel.id]);
      //////// print(currentState);
      try {
        if (currentState is ParticipantListLoading) {
          emit(ParticipantListFetching());
          List listData = await challengeRepository.getChallengeParticipants(requestUrl: requestUrl, token: dioToken);
          //////// print("listData__listData__listData__listData__listData__listData__");
          //////// print(listData);
          if(listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
            ParticipantListResponse fondListResponse = ParticipantListResponse.fromJson(listData[1]);

            //////// print(fondListResponse.data!.users!.length);
            emit(ParticipantListSuccess(dataList: fondListResponse.data!.users ?? [], dataCount: fondListResponse.data!.count ?? 0));
            //////// print("listData__listData__listData__listData__listData__listData__state");
            //////// print(state);
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

            //////// print("fondListResponse.data listData[2]");
            //////// print(listData[2]);
            if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {

              //////// print("fondListResponse.data");
              ParticipantListResponse fondListResponse = ParticipantListResponse.fromJson(listData[1]);
              //////// print("fondListResponse.data");
              //////// print(fondListResponse.data);
              emit(ParticipantListSuccess(dataList: fondListResponse.data!.users ?? [], dataCount: fondListResponse.data!.count ?? 0));
              return;
            }else if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH){
              emit(ParticipantListError(errorCode: listData[2]));
            }
          }
        }
      } catch (exception) {
        //////// print('ParticipantListCubit mapEventToState exception: $exception');
        if (exception is HTTPException) {
          emit(ParticipantListError(errorCode: WEB_SERVICE_ENUM.UNEXCEPTED_ERROR));
        }
      }
  }

  setParticipants(List<ParticipantModel> value, int count)async{
    //////// print("setParticipants________________________________________");
    emit(ParticipantListSuccess(dataList: value, dataCount: count));
  }
}