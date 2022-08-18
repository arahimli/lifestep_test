
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/config/endpoint_config.dart';
import 'package:lifestep/src/tools/config/exception.dart';
import 'package:lifestep/src/models/donation/charities.dart';
import 'package:lifestep/src/models/donation/donors.dart';
import 'package:lifestep/src/ui/donations/details/personal/logic/donors/state.dart';
import 'package:lifestep/src/resources/donation.dart';
import 'package:lifestep/src/resources/service/web_service.dart';
import 'package:sprintf/sprintf.dart';

class DonorListCubit extends  Cubit<DonorListState> {

  final DonationRepository donationRepository;
  final CharityModel charityModel;
  DonorListCubit({required this.donationRepository, required this.charityModel}) : assert(donationRepository != null), super(DonorListLoading()){
    search();
    // //////// print("DonorListCubit--------");
  }

  bool isLoading = false;
  CancelToken dioToken = CancelToken();


  search({bool reset: true}) async {
    var currentState = state;
    if(reset){
      currentState = DonorListLoading();
      emit(DonorListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
    }
    // await Future.delayed(Duration(seconds: 10));
    String requestUrl = sprintf(EndpointConfig.charityUsers, [charityModel.id]);
      //////// print(currentState);
      try {
        if (currentState is DonorListLoading) {
          emit(DonorListLoading());
          List listData = await donationRepository.getCharityDonors(requestUrl: requestUrl, token: dioToken);
          //////// print("listData__listData__listData__listData__listData__listData__");
          //////// print(listData);
          if(listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
            DonorListResponse charityListResponse = DonorListResponse.fromJson(listData[1]);

            //////// print(charityListResponse.data!.donates!.length);
            emit(DonorListSuccess(dataList: charityListResponse.data!.donates ?? [], dataCount: charityListResponse.data!.donateCount ?? 0));
            //////// print("listData__listData__listData__listData__listData__listData__state");
            //////// print(state);
            return;
          }else{

            emit(
                DonorListError(
                  errorCode: listData[2],
                )
            );

          }
        }
        if (currentState is DonorListSuccess) {
          if(!isLoading) {
            isLoading = true;
            List listData = await donationRepository.getCharityDonors(
                requestUrl: requestUrl, token: dioToken);
            isLoading = false;

            //////// print("charityListResponse.data listData[2]");
            //////// print(listData[2]);
            if (listData[2] == WEB_SERVICE_ENUM.SUCCESS) {

              //////// print("charityListResponse.data");
              DonorListResponse charityListResponse = DonorListResponse.fromJson(listData[1]);
              //////// print("charityListResponse.data");
              //////// print(charityListResponse.data);
              emit(DonorListSuccess(dataList: charityListResponse.data!.donates ?? [], dataCount: charityListResponse.data!.donateCount ?? 0));
              return;
            }else if (listData[2] == WEB_SERVICE_ENUM.UN_AUTH){
              emit( DonorListError(errorCode: listData[2]));
            }
          }
        }
      } catch (exception) {
        //////// print('DonorListCubit mapEventToState exception: $exception');
        if (exception is HTTPException) {
          emit(DonorListError(errorCode: WEB_SERVICE_ENUM.UNEXCEPTED_ERROR));
        }
      }
  }

  setDonors(List<DonorModel> value, int count)async{
    //////// print("setDonors________________________________________");
    emit(DonorListSuccess(dataList: value, dataCount: count));
  }

}