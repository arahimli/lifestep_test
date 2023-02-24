import 'package:equatable/equatable.dart';
import 'package:lifestep/features/main_app/data/models/donation/charities.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';

abstract class HealthDataState extends Equatable {
  const HealthDataState();

  @override
  List<Object> get props => [];
}

class HealthDataLoading extends HealthDataState {}

class HealthDataFetching extends HealthDataState {}

class HealthDataSuccess extends HealthDataState {
  final List<CharityModel>? dataList;
  final bool hasReachedMax;

  const HealthDataSuccess({this.dataList = const [], this.hasReachedMax = false});

  HealthDataSuccess copyWith({
    List<CharityModel>? dataList,
    required bool hasReachedMax,
  }) {
    return HealthDataSuccess(
      dataList: dataList ?? this.dataList,
      hasReachedMax: hasReachedMax,
    );
  }

  @override
  List<Object> get props => [dataList ?? [], hasReachedMax];

  @override
  String toString() =>
      'HealthDataSuccess { mainData: ${dataList != null ? dataList!.length : 0}, hasReachedMax: $hasReachedMax }';
}

class HealthDataError extends HealthDataState {
  final WEB_SERVICE_ENUM errorCode;

  const HealthDataError({required this.errorCode});

  @override
  List<Object> get props => [errorCode];
}