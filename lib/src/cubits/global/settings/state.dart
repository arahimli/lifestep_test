import 'package:equatable/equatable.dart';
import 'package:lifestep/src/models/settings/model.dart';
import 'package:lifestep/src/resources/service/web_service.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}


class SettingsLoading extends SettingsState {}

class SettingsStateLoaded extends SettingsState{
  SettingsModel? settingsModel;

  SettingsStateLoaded({
    this.settingsModel,
  });

  @override
  List<Object> get props => [settingsModel!];

  // @override
  // String toString() =>
  //     'SettingsSuccess { mainData: ${dataList != null ? dataList!.length : 0}, hasReachedMax: $hasReachedMax }';
}


class SettingsError extends SettingsState {
  final WEB_SERVICE_ENUM errorCode;

  const SettingsError({required this.errorCode});

  @override
  List<Object> get props => [errorCode];
}