
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/domain/repositories/donation/repository.dart';
import 'package:lifestep/features/tools/config/exception.dart';
import 'package:lifestep/features/main_app/data/models/donation/charities.dart';
import 'package:lifestep/features/main_app/data/models/home/charity_list.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/charity/state.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';

class HomeCharityListCubit extends  Cubit<HomeCharityListState> {

  final IDonationRepository donationRepository;
  HomeCharityListCubit({required this.donationRepository}) : super(HomeCharityListLoading()){
    search();
    // //////// print("HomeCharityListCubit--------");
  }


  bool isLoading = false;
  CancelToken dioToken = CancelToken();

  ScrollController scrollController = ScrollController();
  Future<void> refresh()async{
   ///////// print("refresh");
    await search(reset: true);
  }

  search({bool reset = false}) async {
    var currentState = state;
    if(reset){
      currentState = HomeCharityListLoading();
      emit(HomeCharityListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
    }
    // await Future.delayed( const Duration(seconds: 10));
      //////// print(currentState);
    try {
      if (currentState is HomeCharityListLoading) {
        emit(HomeCharityListFetching());
        List listData = await donationRepository.homeCharities();
        if(listData[2] == WEB_SERVICE_ENUM.success) {
          HomeCharityListResponse homeCharityListResponse = HomeCharityListResponse.fromJson(listData[1]);
          emit(HomeCharityListSuccess(
              dataList: homeCharityListResponse.data));
          return;
        }else{

          emit(
              HomeCharityListError(
                errorCode: listData[2],
                errorText: listData[1],
              )
          );

        }
      }
      if (currentState is HomeCharityListSuccess) {
        if(!isLoading) {
          isLoading = true;
          List listData = await donationRepository.homeCharities();
          isLoading = false;
          if (listData[2] == WEB_SERVICE_ENUM.success) {

            HomeCharityListResponse homeCharityListResponse = HomeCharityListResponse
                .fromJson(listData[1]);
            emit(HomeCharityListSuccess(
                dataList: List.from(currentState.dataList!)
                  ..addAll(homeCharityListResponse.data!),));
            return;
          }else if (listData[2] == WEB_SERVICE_ENUM.unAuth){
            emit( HomeCharityListError(errorCode: listData[2], errorText: listData[1]));
          }
        }
      }
    } catch (exception) {
      //////// print('HomeCharityListCubit mapEventToState exception: $exception');
      if (exception is HTTPException) {
        emit(const HomeCharityListError(errorCode: WEB_SERVICE_ENUM.unexpectedError, errorText: "error_went_wrong"));
      }
    }
  }




  changeCharity({required List<CharityModel> listValue, required CharityModel value, required int index}) async {
    List<CharityModel> returnValue = listValue;
    returnValue[index] = value;
    await Future.delayed( const Duration(milliseconds: 10));

    // emit(HomeCharityListLoading());
    emit(HomeCharityListSuccess(
        dataList: returnValue));
    emit(CharityUpdateListSuccess(
        dataList: returnValue));
  }

  List<CharityModel> updateData(List<CharityModel> listValue, CharityModel value){
    listValue[listValue.indexWhere((element) => element.id == value.id)] = value;
    return listValue;
  }
}