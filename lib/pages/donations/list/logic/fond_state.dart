import 'package:equatable/equatable.dart';
import 'package:lifestep/model/donation/charities.dart';
import 'package:lifestep/model/donation/fonds.dart';
import 'package:lifestep/repositories/service/web_service.dart';

abstract class FondListState extends Equatable {
  const FondListState();

  @override
  List<Object> get props => [];
}

class FondListLoading extends FondListState {}

class FondListFetching extends FondListState {}

class FondListSuccess extends FondListState {
  final List<FondModel>? dataList;
  final bool hasReachedMax;

  const FondListSuccess({this.dataList: const [], this.hasReachedMax:false});

  FondListSuccess copyWith({
    List<FondModel>? dataList,
    required bool hasReachedMax,
  }) {
    return FondListSuccess(
      dataList: dataList ?? this.dataList,
      hasReachedMax: hasReachedMax,
    );
  }

  @override
  List<Object> get props => [dataList ?? [], hasReachedMax];

  @override
  String toString() =>
      'FondListSuccess { mainData: ${dataList != null ? dataList!.length : 0}, hasReachedMax: $hasReachedMax }';
}

class FondUpdateListSuccess extends FondListState {
  final List<FondModel>? dataList;
  final bool hasReachedMax;

  const FondUpdateListSuccess({this.dataList: const [], this.hasReachedMax:false});

  FondUpdateListSuccess copyWith({
    List<FondModel>? dataList,
    required bool hasReachedMax,
  }) {
    return FondUpdateListSuccess(
      dataList: dataList ?? this.dataList,
      hasReachedMax: hasReachedMax,
    );
  }

  @override
  List<Object> get props => [dataList ?? [], hasReachedMax];

  @override
  String toString() =>
      'FondListSuccess { mainData: ${dataList != null ? dataList!.length : 0}, hasReachedMax: $hasReachedMax }';
}

class FondListError extends FondListState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const FondListError({required this.errorCode, required this.errorText});

  @override
  List<Object> get props => [errorCode, errorText];
}