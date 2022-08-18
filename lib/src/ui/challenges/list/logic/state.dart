import 'package:equatable/equatable.dart';
import 'package:lifestep/src/models/challenge/challenges.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

abstract class ChallengeListState extends Equatable {
  const ChallengeListState();

  @override
  List<Object> get props => [];
}

class ChallengeListLoading extends ChallengeListState {}

class ChallengeListFetching extends ChallengeListState {}

class ChallengeListSuccess extends ChallengeListState {
  final List<ChallengeModel>? dataList;
  final bool hasReachedMax;

  const ChallengeListSuccess({this.dataList = const [], this.hasReachedMax = false});

  ChallengeListSuccess copyWith({
    List<ChallengeModel>? dataList,
    required bool hasReachedMax,
  }) {
    return ChallengeListSuccess(
      dataList: dataList ?? this.dataList,
      hasReachedMax: hasReachedMax,
    );
  }

  @override
  List<Object> get props => [dataList ?? [], hasReachedMax];

  @override
  String toString() =>
      'ChallengeListSuccess { mainData: ${dataList != null ? dataList!.length : 0}, hasReachedMax: $hasReachedMax }';
}

class ChallengeListError extends ChallengeListState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const ChallengeListError({required this.errorCode, required this.errorText, });

  @override
  List<Object> get props => [errorCode];
}