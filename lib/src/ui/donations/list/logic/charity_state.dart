import 'package:equatable/equatable.dart';
import 'package:lifestep/src/models/donation/charities.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

abstract class CharityListState extends Equatable {
  const CharityListState();

  @override
  List<Object> get props => [];
}

class CharityListLoading extends CharityListState {}

class CharityListFetching extends CharityListState {}

class CharityListSuccess extends CharityListState {
  final List<CharityModel>? dataList;
  final bool hasReachedMax;

  const CharityListSuccess({this.dataList = const [], this.hasReachedMax = false});

  CharityListSuccess copyWith({
    List<CharityModel>? dataList,
    required bool hasReachedMax,
  }) {
    return CharityListSuccess(
      dataList: dataList ?? this.dataList,
      hasReachedMax: hasReachedMax,
    );
  }

  @override
  List<Object> get props => [dataList ?? [], hasReachedMax];

  @override
  String toString() =>
      'CharityListSuccess { mainData: ${dataList != null ? dataList!.length : 0}, hasReachedMax: $hasReachedMax }';
}

class CharityUpdateListSuccess extends CharityListState {
  final List<CharityModel>? dataList;
  final bool hasReachedMax;

  const CharityUpdateListSuccess({this.dataList = const [], this.hasReachedMax = false});

  CharityUpdateListSuccess copyWith({
    List<CharityModel>? dataList,
    required bool hasReachedMax,
  }) {
    return CharityUpdateListSuccess(
      dataList: dataList ?? this.dataList,
      hasReachedMax: hasReachedMax,
    );
  }

  @override
  List<Object> get props => [dataList ?? [], hasReachedMax];

  @override
  String toString() =>
      'CharityListSuccess { mainData: ${dataList != null ? dataList!.length : 0}, hasReachedMax: $hasReachedMax }';
}

class CharityListError extends CharityListState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const CharityListError({required this.errorCode, required this.errorText});

  @override
  List<Object> get props => [errorCode, errorText];
}