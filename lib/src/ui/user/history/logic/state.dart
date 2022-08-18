import 'package:equatable/equatable.dart';
import 'package:lifestep/src/models/donation/donation-history.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

abstract class DonationHistoryListState extends Equatable {
  const DonationHistoryListState();

  @override
  List<Object> get props => [];
}

class DonationHistoryListLoading extends DonationHistoryListState {}

class DonationHistoryListFetching extends DonationHistoryListState {}

class DonationHistoryListSuccess extends DonationHistoryListState {
  final List<DonationHistoryModel>? dataList;
  final bool hasReachedMax;

  const DonationHistoryListSuccess({this.dataList = const [], this.hasReachedMax = false});

  DonationHistoryListSuccess copyWith({
    List<DonationHistoryModel>? dataList,
    required bool hasReachedMax,
  }) {
    return DonationHistoryListSuccess(
      dataList: dataList ?? this.dataList,
      hasReachedMax: hasReachedMax,
    );
  }

  @override
  List<Object> get props => [dataList ?? [], hasReachedMax];

  @override
  String toString() =>
      'DonationHistoryListSuccess { mainData: ${dataList != null ? dataList!.length : 0}, hasReachedMax: $hasReachedMax }';
}

class DonationHistoryListError extends DonationHistoryListState {
  final WEB_SERVICE_ENUM errorCode;
  final String errorText;

  const DonationHistoryListError({required this.errorCode, required this.errorText });

  @override
  List<Object> get props => [errorCode];
}