import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/data/models/index/banner.dart';
import 'package:lifestep/features/main_app/data/models/index/page.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/main/state.dart';
import 'package:lifestep/features/main_app/domain/repositories/home/repository.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';

class IndexCubit extends Cubit<IndexState>{
  IndexCubit({required this.homeRepository}) : super(IndexLoading()) {
    initialize();
  }
  final IHomeRepository homeRepository;
  Future<void> initialize() async{

    IndexPageModel indexPageModel = IndexPageModel();
    List sliderList = await getSlider();
    if(sliderList[2] != WEB_SERVICE_ENUM.success){
      if (sliderList[2] != WEB_SERVICE_ENUM.unAuth){
        emit(AuthError());
        return;
      }
      else if (sliderList[2] != WEB_SERVICE_ENUM.internetError) {
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
    }


    emit(IndexLoaded(indexPageModel: indexPageModel));

  }



  Future<void> refresh() async{

    IndexPageModel indexPageModel = IndexPageModel();
    List sliderList = await getSlider();
    if(sliderList[2] != WEB_SERVICE_ENUM.success){
      if (sliderList[2] != WEB_SERVICE_ENUM.unAuth){
        emit(state);
        return;
      }
      else if (sliderList[2] != WEB_SERVICE_ENUM.internetError) {
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
    }

    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


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