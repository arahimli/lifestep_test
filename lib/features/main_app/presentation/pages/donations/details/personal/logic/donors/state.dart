import 'package:equatable/equatable.dart';
import 'package:lifestep/features/main_app/data/models/donation/donors.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';

abstract class DonorListState extends Equatable {
  const DonorListState();

  @override
  List<Object> get props => [];
}

class DonorListLoading extends DonorListState {}

class DonorListSuccess extends DonorListState {
  final List<DonorModel> dataList;
  final int dataCount;

  const DonorListSuccess({this.dataList = const [], this.dataCount= 0, });

  DonorListSuccess copyWith({
    required List<DonorModel> dataList,
    required int dataCount,
  }) {
    return DonorListSuccess(
      dataList: dataList,
      dataCount: dataCount,
    );
  }

  @override
  List<Object> get props => [dataList, dataCount];

  @override
  String toString() => 'DonorListSuccess { mainData: ${dataList.length } }';
}

class DonorListError extends DonorListState {
  final WEB_SERVICE_ENUM errorCode;

  const DonorListError({required this.errorCode});

  @override
  List<Object> get props => [errorCode];
}