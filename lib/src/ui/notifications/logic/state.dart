import 'package:equatable/equatable.dart';
import 'package:lifestep/src/models/common/notifications.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

abstract class NotificationListState extends Equatable {
  const NotificationListState();

  @override
  List<Object> get props => [];
}

class NotificationListLoading extends NotificationListState {}

class NotificationListFetching extends NotificationListState {}

class NotificationListSuccess extends NotificationListState {
  final List<NotificationModel>? dataList;
  final bool hasReachedMax;

  const NotificationListSuccess({this.dataList = const [], this.hasReachedMax = false});

  NotificationListSuccess copyWith({
    List<NotificationModel>? dataList,
    required bool hasReachedMax,
  }) {
    return NotificationListSuccess(
      dataList: dataList ?? this.dataList,
      hasReachedMax: hasReachedMax,
    );
  }

  @override
  List<Object> get props => [dataList ?? [], hasReachedMax];

  @override
  String toString() =>
      'NotificationListSuccess { mainData: ${dataList != null ? dataList!.length : 0}, hasReachedMax: $hasReachedMax }';
}

class NotificationListError extends NotificationListState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const NotificationListError({required this.errorCode, required this.errorText});

  @override
  List<Object> get props => [errorCode];
}