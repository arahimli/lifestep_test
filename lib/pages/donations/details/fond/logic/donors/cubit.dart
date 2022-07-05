
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/config/exception.dart';
import 'package:lifestep/model/donation/donors.dart';
import 'package:lifestep/model/donation/fonds.dart';
import 'package:lifestep/pages/donations/details/fond/logic/donors/state.dart';
import 'package:lifestep/pages/donations/details/personal/logic/donors/state.dart';
import 'package:lifestep/repositories/donation.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:sprintf/sprintf.dart';

class FondDonorListCubit extends  Cubit<FondDonorListState> {

  final DonationRepository donationRepository;
  final FondModel fondModel;
  FondDonorListCubit({required this.donationRepository, required this.fondModel}) : assert(donationRepository != null), super(FondDonorListLoading()){
    this.search();
    // //////// print("FondDonorListCubit--------");
  }

  bool isLoading = false;
  CancelToken dioToken = CancelToken();


  search({bool reset: true}) async {
    var currentState = state;
    if(reset){
      currentState = FondDonorListLoading();
      emit(FondDonorListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
    }
    String requestUrl = sprintf(FOND_USERS_URL, [fondModel.id]);
      //////// print(currentState);
      try {
        if (currentState is FondDonorListLoading) {
          emit(FondDonorListFetching());
          List listData = await donationRepository.getFondDonors(requestUrl: requestUrl, token: dioToken);
          //////// print("listData__listData__listData__listData__listData__listData__");
          //////// print(listData);
          if(listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
            DonorListResponse fondListResponse = DonorListResponse.fromJson(listData[1]);

            //////// print(fondListResponse.data!.donates!.length);
            emit(FondDonorListSuccess(dataList: fondListResponse.data!.donates ?? [], dataCount: fondListResponse.data!.donateCount ?? 0));
            //////// print("listData__listData__listData__listData__listData__listData__state");
            //////// print(state);
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

            //////// print("fondListResponse.data listData[2]");
            //////// print(listData[2]);
            if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {

              //////// print("fondListResponse.data");
              DonorListResponse fondListResponse = DonorListResponse.fromJson(listData[1]);
              //////// print("fondListResponse.data");
              //////// print(fondListResponse.data);
              emit(FondDonorListSuccess(dataList: fondListResponse.data!.donates ?? [], dataCount: fondListResponse.data!.donateCount ?? 0));
              return;
            }else if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH){
              emit( FondDonorListError(errorCode: listData[2]));
            }
          }
        }
      } catch (exception) {
        //////// print('FondDonorListCubit mapEventToState exception: $exception');
        if (exception is HTTPException) {
          emit(FondDonorListError(errorCode: WEB_SERVICE_ENUM.UNEXCEPTED_ERROR));
        }
      }
  }

  setDonors(List<DonorModel> value, int count)async{
    //////// print("setDonors________________________________________");
    emit(FondDonorListSuccess(dataList: value, dataCount: count));
  }
}