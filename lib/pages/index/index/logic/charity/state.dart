import 'package:equatable/equatable.dart';
import 'package:lifestep/model/donation/charities.dart';
import 'package:lifestep/repositories/service/web_service.dart';

abstract class HomeCharityListState extends Equatable {
  const HomeCharityListState();

  @override
  List<Object> get props => [];
}

class HomeCharityListLoading extends HomeCharityListState {}

class HomeCharityListFetching extends HomeCharityListState {}

class HomeCharityListSuccess extends HomeCharityListState {
  final List<CharityModel>? dataList;

  const HomeCharityListSuccess({this.dataList: const []});

  HomeCharityListSuccess copyWith({
    List<CharityModel>? dataList,
    required bool hasReachedMax,
  }) {
    return HomeCharityListSuccess(
      dataList: dataList ?? this.dataList,
    );
  }

  @override
  List<Object> get props => [dataList ?? []];

  @override
  String toString() =>
      'HomeCharityListSuccess { mainData: ${dataList != null ? dataList!.length : 0},}';
}

class CharityUpdateListSuccess extends HomeCharityListState {
  final List<CharityModel>? dataList;

  const CharityUpdateListSuccess({this.dataList: const []});

  CharityUpdateListSuccess copyWith({
    List<CharityModel>? dataList,
  }) {
    return CharityUpdateListSuccess(
      dataList: dataList ?? this.dataList,
    );
  }

  @override
  List<Object> get props => [dataList ?? []];

  @override
  String toString() =>
      'HomeCharityListSuccess { mainData: ${dataList != null ? dataList!.length : 0}, hasReachedMax}';
}

class HomeCharityListError extends HomeCharityListState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const HomeCharityListError({required this.errorCode, required this.errorText});

  @override
  List<Object> get props => [errorCode, errorText];
}