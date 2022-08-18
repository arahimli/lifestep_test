import 'package:equatable/equatable.dart';
import 'package:lifestep/src/ui/apploading/logic/cubit.dart';

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