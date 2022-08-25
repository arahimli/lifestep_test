import 'package:equatable/equatable.dart';
import 'package:lifestep/src/models/challenge/participants.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

abstract class ParticipantListState extends Equatable {
  const ParticipantListState();

  @override
  List<Object> get props => [];
}

class ParticipantListLoading extends ParticipantListState {}

class ParticipantListFetching extends ParticipantListState {}

class ParticipantListSuccess extends ParticipantListState {
  final List<ParticipantModel> dataList;
  final int dataCount;

  const ParticipantListSuccess({this.dataList = const [], this.dataCount= 0, });

  ParticipantListSuccess copyWith({
    required List<ParticipantModel> dataList,
    required int dataCount,
  }) {
    return ParticipantListSuccess(
      dataList: dataList,
      dataCount: dataCount,
    );
  }

  @override
  List<Object> get props => [dataList, dataCount];

  @override
  String toString() =>
      'ParticipantListSuccess { mainData: ${dataList.length} }';
}

class ParticipantListError extends ParticipantListState {
  final WEB_SERVICE_ENUM errorCode;

  const ParticipantListError({required this.errorCode});

  @override
  List<Object> get props => [errorCode];
}