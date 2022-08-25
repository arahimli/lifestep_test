import 'package:equatable/equatable.dart';
import 'package:lifestep/src/models/general/achievement_list.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

abstract class AchievementListState extends Equatable {
  const AchievementListState();

  @override
  List<Object> get props => [];
}

class AchievementListLoading extends AchievementListState {}

class AchievementListFetching extends AchievementListState {}

class AchievementListSuccess extends AchievementListState {
  final List<AchievementModel> dataList;
  final List<UserAchievementModel> userDataList;

  const AchievementListSuccess({this.dataList = const [], this.userDataList = const [], });

  AchievementListSuccess copyWith({
    required List<AchievementModel> dataList,
    required List<UserAchievementModel> userDataList,
    required int dataCount,
  }) {
    return AchievementListSuccess(
      dataList: dataList,
      userDataList: userDataList,
    );
  }

  List<AchievementModel> getUniqueList(){
    List newList = userDataList.map((e) => e.achievementId).toList();
    return dataList.where((element) => !newList.contains(element.id)).toList();
  }

  @override
  List<Object> get props => [dataList, userDataList];

  @override
  String toString() =>
      'AchievementListSuccess { mainData: ${dataList.length } }';
}

class AchievementListError extends AchievementListState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const AchievementListError({required this.errorCode, required this.errorText});

  @override
  List<Object> get props => [errorCode];
}