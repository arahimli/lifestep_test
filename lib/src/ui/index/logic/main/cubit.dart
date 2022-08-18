import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/models/home/challenge-list.dart';
import 'package:lifestep/src/models/home/fond-list.dart';
import 'package:lifestep/src/models/index/banner.dart';
import 'package:lifestep/src/models/index/page.dart';
import 'package:lifestep/src/ui/index/logic/main/state.dart';
import 'package:lifestep/src/resources/home.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

class IndexCubit extends Cubit<IndexState>{
  IndexCubit({required this.homeRepository}) : super(IndexLoading()) {
    initialize();
  }
  final HomeRepository homeRepository;
  Future<void> initialize() async{

    IndexPageModel indexPageModel = IndexPageModel();
    List sliderList = await getSlider();
    if(sliderList[2] != WEB_SERVICE_ENUM.SUCCESS){
      if (sliderList[2] != WEB_SERVICE_ENUM.UN_AUTH){
        emit(AuthError());
        return;
      }
      else if (sliderList[2] != WEB_SERVICE_ENUM.INTERNET_ERROR) {
        emit(InternetError());
        return;
      }
      else{
        emit(IndexError());
        return;
      }
    }else{
      BannerResponse bannerResponse = BannerResponse.fromJson(sliderList[1]);
      indexPageModel = indexPageModel.copyWith(bannerData: bannerResponse.data);
      //////// print(bannerResponse.data);
      //////// print("Future<void> initialize() async{ else");
    }

    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    // List charityList = await this.homeCharities();
    // if(charityList[2] != WEB_SERVICE_ENUM.SUCCESS){
    //   if (charityList[2] != WEB_SERVICE_ENUM.UN_AUTH){
    //     emit(AuthError());
    //     return;
    //   }
    //   else if (charityList[2] != WEB_SERVICE_ENUM.INTERNET_ERROR) {
    //     emit(InternetError());
    //     return;
    //   }
    //   else{
    //     emit(IndexError());
    //     return;
    //   }
    // }else{
    //   HomeCharityListResponse homeCharityListResponse = HomeCharityListResponse.fromJson(charityList[1]);
    //   indexPageModel = indexPageModel.copyWith(charityList: homeCharityListResponse.data);
    //   //////// print(homeCharityListResponse.data);
    //   //////// print("Future<void> initialize() async{ else");
    // }

    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    // List fondList = await this.homeFonds();
    // if(fondList[2] != WEB_SERVICE_ENUM.SUCCESS){
    //   if (fondList[2] != WEB_SERVICE_ENUM.UN_AUTH){
    //     emit(AuthError());
    //     return;
    //   }
    //   else if (fondList[2] != WEB_SERVICE_ENUM.INTERNET_ERROR) {
    //     emit(InternetError());
    //     return;
    //   }
    //   else{
    //     emit(IndexError());
    //     return;
    //   }
    // }else{
    //   HomeFondListResponse homeFondListResponse = HomeFondListResponse.fromJson(fondList[1]);
    //   indexPageModel = indexPageModel.copyWith(fondList: homeFondListResponse.data);
    //   //////// print(homeFondListResponse.data);
    //   //////// print("Future<void> initialize() async{ else");
    // }
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    List challengeList = await homeChallenges()
    ;
    if(challengeList[2] != WEB_SERVICE_ENUM.SUCCESS){
      if (challengeList[2] != WEB_SERVICE_ENUM.UN_AUTH){
        emit(AuthError());
        return;
      }
      else if (challengeList[2] != WEB_SERVICE_ENUM.INTERNET_ERROR) {
        emit(InternetError());
        return;
      }
      else{
        emit(IndexError());
        return;
      }
    }else{
      HomeChallengeListResponse homeChallengeListResponse = HomeChallengeListResponse.fromJson(challengeList[1]);
      indexPageModel = indexPageModel.copyWith(challengeList: homeChallengeListResponse.data);
      //////// print(homeChallengeListResponse.data);
      //////// print("Future<void> initialize() async{ else");
    }

    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


    //////// print("Future<void> initialize() async{ final");
    emit(IndexLoaded(indexPageModel: indexPageModel));

  }



  Future<void> refresh() async{

    IndexPageModel indexPageModel = IndexPageModel();
    List sliderList = await getSlider();
    if(sliderList[2] != WEB_SERVICE_ENUM.SUCCESS){
      if (sliderList[2] != WEB_SERVICE_ENUM.UN_AUTH){
        emit(state);
        return;
      }
      else if (sliderList[2] != WEB_SERVICE_ENUM.INTERNET_ERROR) {
        emit(state);
        return;
      }
      else{
        emit(state);
        return;
      }
    }else{
      BannerResponse bannerResponse = BannerResponse.fromJson(sliderList[1]);
      indexPageModel = indexPageModel.copyWith(bannerData: bannerResponse.data);
      //////// print(bannerResponse.data);
      //////// print("Future<void> refresh() async{ else");
    }

    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    //
    // List charityList = await this.homeCharities();
    // if(charityList[2] != WEB_SERVICE_ENUM.SUCCESS){
    //   if (charityList[2] != WEB_SERVICE_ENUM.UN_AUTH){
    //     emit(state);
    //     return;
    //   }
    //   else if (charityList[2] != WEB_SERVICE_ENUM.INTERNET_ERROR) {
    //     emit(state);
    //     return;
    //   }
    //   else{
    //     emit(state);
    //     return;
    //   }
    // }else{
    //   HomeCharityListResponse homeCharityListResponse = HomeCharityListResponse.fromJson(charityList[1]);
    //   indexPageModel = indexPageModel.copyWith(charityList: homeCharityListResponse.data);
    //   //////// print(homeCharityListResponse.data);
    //   //////// print("Future<void> refresh() async{ else");
    // }

    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    List fondList = await homeFonds();
    if(fondList[2] != WEB_SERVICE_ENUM.SUCCESS){
      if (fondList[2] != WEB_SERVICE_ENUM.UN_AUTH){
        emit(state);
        return;
      }
      else if (fondList[2] != WEB_SERVICE_ENUM.INTERNET_ERROR) {
        emit(state);
        return;
      }
      else{
        emit(state);
        return;
      }
    }else{
      HomeFondListResponse homeFondListResponse = HomeFondListResponse.fromJson(fondList[1]);
      indexPageModel = indexPageModel.copyWith(fondList: homeFondListResponse.data);
      //////// print(homeFondListResponse.data);
      //////// print("Future<void> refresh() async{ else");
    }
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    List challengeList = await homeChallenges()
    ;
    if(challengeList[2] != WEB_SERVICE_ENUM.SUCCESS){
      if (challengeList[2] != WEB_SERVICE_ENUM.UN_AUTH){
        emit(state);
        return;
      }
      else if (challengeList[2] != WEB_SERVICE_ENUM.INTERNET_ERROR) {
        emit(state);
        return;
      }
      else{
        emit(state);
        return;
      }
    }else{
      HomeChallengeListResponse homeChallengeListResponse = HomeChallengeListResponse.fromJson(challengeList[1]);
      indexPageModel = indexPageModel.copyWith(challengeList: homeChallengeListResponse.data);
      //////// print(homeChallengeListResponse.data);
      //////// print("Future<void> refresh() async{ else");
    }

    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


    //////// print("Future<void> refresh() async{ final");
    emit(IndexLoaded(indexPageModel: indexPageModel));

  }

  Future<List> getSlider() async{
    List result = await homeRepository.getSlider();
    return result;
  }

  // Future<List> homeCharities() async{
  //   List result = await homeRepository.homeCharities();
  //   return result;
  // }

  Future<List> homeFonds() async{
    List result = await homeRepository.homeFonds();
    return result;
  }
  Future<List> homeChallenges() async{
    List result = await homeRepository.homeChallenges();
    return result;
  }


}