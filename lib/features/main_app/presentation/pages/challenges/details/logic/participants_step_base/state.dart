import 'package:equatable/equatable.dart';
import 'package:lifestep/features/main_app/data/models/challenge/participants_step_base.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:lifestep/features/tools/common/utlis.dart';

abstract class StepBaseParticipantListState extends Equatable {
  const StepBaseParticipantListState();

  @override
  List<Object> get props => [];
}

class StepBaseParticipantListLoading extends StepBaseParticipantListState {}

class StepBaseParticipantListFetching extends StepBaseParticipantListState {}

class StepBaseParticipantListSuccess extends StepBaseParticipantListState {
  final List<StepBaseParticipantModel> dataList;
  final String? hash;

  const StepBaseParticipantListSuccess({this.dataList = const [], this.hash});

  StepBaseParticipantListSuccess copyWith({
    required List<StepBaseParticipantModel> dataList,
    required String? hash,
  }) {
    return StepBaseParticipantListSuccess(
      dataList: dataList,
      hash: hash ?? Utils.generateRandomString(10),
    );
  }

  @override
  List<Object> get props => [dataList, hash ?? ''];

  @override
  String toString() =>
      'StepBaseParticipantListSuccess { mainData: ${dataList.length} }';
}

class StepBaseParticipantListError extends StepBaseParticipantListState {
  final WEB_SERVICE_ENUM errorCode;

  const StepBaseParticipantListError({required this.errorCode});

  @override
  List<Object> get props => [errorCode];
}