import 'package:equatable/equatable.dart';
import 'package:lifestep/features/main_app/data/models/challenge/challenges.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:lifestep/features/tools/common/utlis.dart';

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
  final String hash;

  const ChallengeListSuccess({this.dataList = const [], this.hasReachedMax = false, required this.hash});

  ChallengeListSuccess copyWith({
    List<ChallengeModel>? dataList,
    required bool hasReachedMax,
    String? hash,
  }) {
    return ChallengeListSuccess(
      dataList: dataList ?? this.dataList,
      hasReachedMax: hasReachedMax,
      hash: hash ?? Utils.generateRandomString(10),
    );
  }

  @override
  List<Object> get props => [dataList ?? [], hasReachedMax, hash];

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