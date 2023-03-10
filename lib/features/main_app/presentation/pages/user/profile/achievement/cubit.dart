
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/tools/config/exception.dart';
import 'package:lifestep/features/main_app/data/models/general/achievement_list.dart';
// import 'package:lifestep/features/main_app/data/models/auth/achievements.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/profile/achievement/state.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/repositories/auth.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';




class AchievementListCubit extends  Cubit<AchievementListState> {

  final UserRepository authRepo;
  AchievementListCubit({required this.authRepo}) : super(AchievementListLoading()){
    search();
  }

  List<Map<String, dynamic>> listValues = [
    {
      "title": 'profile_view___tab_achievements__list_item_title_1',
      "description": 'profile_view___tab_achievements__list_item_description_1',
      "image": 'assets/svgs/achievements/1.svg',
    },
    {
      "title": 'profile_view___tab_achievements__list_item_title_2',
      "description": 'profile_view___tab_achievements__list_item_description_2',
      "image": 'assets/svgs/achievements/2.svg',
    },
    {
      "title": 'profile_view___tab_achievements__list_item_title_3',
      "description": 'profile_view___tab_achievements__list_item_description_3',
      "image": 'assets/svgs/achievements/3.svg',
    },
    {
      "title": 'profile_view___tab_achievements__list_item_title_4',
      "description": 'profile_view___tab_achievements__list_item_description_4',
      "image": 'assets/svgs/achievements/4.svg',
    },
  ];

  bool isLoading = false;
  CancelToken dioToken = CancelToken();

  Future<void> refresh()async{
    await search(reset: true);
  }

  search({bool reset= false}) async {
    var currentState = state;
    if(reset){
      currentState = AchievementListLoading();
      emit(AchievementListLoading());
      dioToken.cancel();
      dioToken = CancelToken();
    }

    // await Future.delayed( const Duration(seconds: 20));
      try {
        if (currentState is AchievementListLoading) {
          emit(AchievementListFetching());
          List listData = await authRepo.getAchievements(token: dioToken);
          if(listData[2] == WEB_SERVICE_ENUM.success) {
            AchievementListResponse achievementListResponse = AchievementListResponse.fromJson(listData[1]);

            emit(AchievementListSuccess(dataList: achievementListResponse.data!.achievements ?? [], userDataList: achievementListResponse.data!.userAchievements ?? []));
            return;
          }else{

            emit(
                AchievementListError(
                  errorCode: listData[2],
                  errorText: listData[1],
                )
            );

          }
        }
        if (currentState is AchievementListSuccess) {
          if(!isLoading) {
            isLoading = true;
            List listData = await authRepo.getAchievements(token: dioToken);
            isLoading = false;

            // await Future.delayed( const Duration(seconds: 1));
            // emit(AchievementListSuccess(dataList: resultData));
            // emit(AchievementListSuccess(dataList: achievementListResponse.data ?? []));
            ////// print("achievementListResponse.data listData[2]");
            //////// print(listData[2]);
            if (listData[2] == WEB_SERVICE_ENUM.success) {

              //////// print("achievementListResponse.data");
              AchievementListResponse achievementListResponse = AchievementListResponse.fromJson(listData[1]);
              //////// print("achievementListResponse.data");
              //////// print(achievementListResponse.data);
              emit(AchievementListSuccess(dataList: achievementListResponse.data!.achievements ?? [], userDataList: achievementListResponse.data!.userAchievements ?? []));
              return;
            }else if (listData[2] == WEB_SERVICE_ENUM.unAuth){
              emit( AchievementListError(errorCode: listData[2], errorText: listData[1]));
            }
          }
        }
      } catch (exception) {
        //////// print('AchievementListCubit mapEventToState exception: $exception');
        if (exception is HTTPException) {
          emit(const AchievementListError(errorCode: WEB_SERVICE_ENUM.unexpectedError, errorText: "error_went_wrong"));
        }
      }
  }
}


//
// class AchievementModel {
//   int? id;
//   String? name;
//   String? description;
//   String? startDate;
//   String? endDate;
//   String? image;
//   int requiredSteps = 0;
//   int presentSteps = 0;
//   double? amount;
//   int? status;
//   String? sponsorImage;
//   String? sponsorName;
//
//   AchievementModel(
//       {this.id,
//         this.name,
//         this.description,
//         this.startDate,
//         this.endDate,
//         this.image,
//         this.requiredSteps: 0,
//         this.presentSteps: 0,
//         this.amount,
//         this.status,
//         this.sponsorImage,
//         this.sponsorName});
//
// }
