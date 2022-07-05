import 'package:equatable/equatable.dart';
import 'package:lifestep/model/donation/charities.dart';
import 'package:lifestep/pages/apploading/logic/cubit.dart';
import 'package:lifestep/repositories/service/web_service.dart';

abstract class ApploadingState extends Equatable {
  const ApploadingState();

  @override
  List<Object> get props => [];
}

class ApploadingLoading extends ApploadingState {}

class ApploadingResult extends ApploadingState {
  final AppLoadingModel result;

  const ApploadingResult({required this.result});

  ApploadingResult copyWith({
    required AppLoadingModel result,
  }) {
    return ApploadingResult(
      result: result,
    );
  }

  @override
  List<Object> get props => [result];

  @override
  String toString() =>
      'ApploadingSuccess { mainData: ${result.isLogin}}';
}