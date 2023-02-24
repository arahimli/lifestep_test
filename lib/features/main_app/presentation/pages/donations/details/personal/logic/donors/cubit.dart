
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/domain/repositories/donation/repository.dart';
import 'package:lifestep/features/tools/config/endpoint_config.dart';
import 'package:lifestep/features/tools/config/exception.dart';
import 'package:lifestep/features/main_app/data/models/donation/charities.dart';
import 'package:lifestep/features/main_app/data/models/donation/donors.dart';
import 'package:lifestep/features/main_app/presentation/pages/donations/details/personal/logic/donors/state.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:sprintf/sprintf.dart';

class DonorListCubit extends  Cubit<DonorListState> {

  final IDonationRepository donationRepository;
  final CharityModel charityModel;
  DonorListCubit({required this.donationRepository, required this.charityModel}) : super(DonorListLoading()){
    search();
  }

  bool isLoading = false;
  CancelToken dioToken = CancelToken();


  search({bool reset= true}) async {
    var currentState = state;
    if(reset){
      currentState = DonorListLoading();
      emit(DonorListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
    }
    // await Future.delayed( const Duration(seconds: 10));
    String requestUrl = sprintf(EndpointConfig.charityUsers, [charityModel.id]);
      try {
        if (currentState is DonorListLoading) {
          emit(DonorListLoading());
          List listData = await donationRepository.getCharityDonors(requestUrl: requestUrl, token: dioToken);
          if(listData[2] == WEB_SERVICE_ENUM.success) {
            DonorListResponse charityListResponse = DonorListResponse.fromJson(listData[1]);

            emit(DonorListSuccess(dataList: charityListResponse.data!.donates ?? [], dataCount: charityListResponse.data!.donateCount ?? 0));
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

            if (listData[2] == WEB_SERVICE_ENUM.success) {

              DonorListResponse charityListResponse = DonorListResponse.fromJson(listData[1]);
              emit(DonorListSuccess(dataList: charityListResponse.data!.donates ?? [], dataCount: charityListResponse.data!.donateCount ?? 0));
              return;
            }else if (listData[2] == WEB_SERVICE_ENUM.unAuth){
              emit( DonorListError(errorCode: listData[2]));
            }
          }
        }
      } catch (exception) {
        if (exception is HTTPException) {
          emit(const DonorListError(errorCode: WEB_SERVICE_ENUM.unexpectedError));
        }
      }
  }

  setDonors(List<DonorModel> value, int count)async{
    emit(DonorListSuccess(dataList: value, dataCount: count));
  }

}