import 'package:equatable/equatable.dart';
import 'package:lifestep/src/models/challenge/challenges.dart';
import 'package:lifestep/src/models/home/challenge_list.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

abstract class HomeChallengeListState extends Equatable {
  const HomeChallengeListState();

  @override
  List<Object> get props => [];
}

class HomeChallengeListLoading extends HomeChallengeListState {}

class HomeChallengeListFetching extends HomeChallengeListState {}

class HomeChallengeListSuccess extends HomeChallengeListState {
  final List<ChallengeModel>? dataList;
  final List<StepInnerModel>? stepInnerList;
  final String hash;

  const HomeChallengeListSuccess({this.dataList = const [], this.stepInnerList = const [], required this.hash, });

  HomeChallengeListSuccess copyWith({
    List<ChallengeModel>? dataList,
    List<StepInnerModel>? stepInnerList,
    String? hash,
  }) {
    return HomeChallengeListSuccess(
      dataList: dataList ?? this.dataList,
      stepInnerList: stepInnerList ?? this.stepInnerList,
      hash: hash ?? this.hash,
    );
  }

  @override
  List<Object> get props => [dataList ?? [], hash];

  @override
  String toString() =>
      'HomeChallengeListSuccess { mainData: ${dataList != null ? dataList!.length : 0},}';
}


class HomeChallengeListError extends HomeChallengeListState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const HomeChallengeListError({required this.errorCode, required this.errorText});

  @override
  List<Object> get props => [errorCode, errorText];
}