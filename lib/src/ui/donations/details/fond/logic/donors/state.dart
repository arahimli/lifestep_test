import 'package:equatable/equatable.dart';
import 'package:lifestep/src/models/donation/donors.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

abstract class FondDonorListState extends Equatable {
  const FondDonorListState();

  @override
  List<Object> get props => [];
}

class FondDonorListLoading extends FondDonorListState {}

class FondDonorListFetching extends FondDonorListState {}

class FondDonorListSuccess extends FondDonorListState {
  final List<DonorModel> dataList;
  final int dataCount;

  const FondDonorListSuccess({this.dataList = const [], this.dataCount: 0, });

  FondDonorListSuccess copyWith({
    required List<DonorModel> dataList,
    required int dataCount,
  }) {
    return FondDonorListSuccess(
      dataList: dataList,
      dataCount: dataCount,
    );
  }

  @override
  List<Object> get props => [dataList, dataCount];

  @override
  String toString() =>
      'FondDonorListSuccess { mainData: ${dataList != null ? dataList.length : 0} }';
}

class FondDonorListError extends FondDonorListState {
  final WEB_SERVICE_ENUM errorCode;

  const FondDonorListError({required this.errorCode});

  @override
  List<Object> get props => [errorCode];
}