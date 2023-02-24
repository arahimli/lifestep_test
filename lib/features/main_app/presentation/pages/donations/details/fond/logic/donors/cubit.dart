
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/domain/repositories/donation/repository.dart';
import 'package:lifestep/features/tools/config/endpoint_config.dart';
import 'package:lifestep/features/tools/config/exception.dart';
import 'package:lifestep/features/main_app/data/models/donation/donors.dart';
import 'package:lifestep/features/main_app/data/models/donation/fonds.dart';
import 'package:lifestep/features/main_app/presentation/pages/donations/details/fond/logic/donors/state.dart';

import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:sprintf/sprintf.dart';

class FondDonorListCubit extends  Cubit<FondDonorListState> {

  final IDonationRepository donationRepository;
  final FondModel fondModel;
  FondDonorListCubit({required this.donationRepository, required this.fondModel}) : super(FondDonorListLoading()){
    search();
  }

  bool isLoading = false;
  CancelToken dioToken = CancelToken();


  search({bool reset= true}) async {
    var currentState = state;
    if(reset){
      currentState = FondDonorListLoading();
      emit(FondDonorListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
    }
    String requestUrl = sprintf(EndpointConfig.fundUsers, [fondModel.id]);
      try {
        if (currentState is FondDonorListLoading) {
          emit(FondDonorListFetching());
          List listData = await donationRepository.getFondDonors(requestUrl: requestUrl, token: dioToken);
          if(listData[2] == WEB_SERVICE_ENUM.success) {
            DonorListResponse fondListResponse = DonorListResponse.fromJson(listData[1]);

            emit(FondDonorListSuccess(dataList: fondListResponse.data!.donates ?? [], dataCount: fondListResponse.data!.donateCount ?? 0));
            return;
          }else{

            emit(
                FondDonorListError(
                  errorCode: listData[2],
                )
            );
          }
        }
        if (currentState is FondDonorListSuccess) {
          if(!isLoading) {
            isLoading = true;
            List listData = await donationRepository.getFondDonors(
                requestUrl: requestUrl, token: dioToken);
            isLoading = false;

            if (listData[2] == WEB_SERVICE_ENUM.success) {

              DonorListResponse fondListResponse = DonorListResponse.fromJson(listData[1]);
              emit(FondDonorListSuccess(dataList: fondListResponse.data!.donates ?? [], dataCount: fondListResponse.data!.donateCount ?? 0));
              return;
            }else if (listData[2] == WEB_SERVICE_ENUM.unAuth){
              emit( FondDonorListError(errorCode: listData[2]));
            }
          }
        }
      } catch (exception) {
        if (exception is HTTPException) {
          emit(const FondDonorListError(errorCode: WEB_SERVICE_ENUM.unexpectedError));
        }
      }
  }

  setDonors(List<DonorModel> value, int count)async{
    emit(FondDonorListSuccess(dataList: value, dataCount: count));
  }
}