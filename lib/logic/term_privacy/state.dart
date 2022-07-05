import 'package:equatable/equatable.dart';
import 'package:lifestep/model/static/terms_privacy.dart';
import 'package:lifestep/repositories/service/web_service.dart';

abstract class TermsPrivacyState extends Equatable {
  const TermsPrivacyState();

  @override
  List<Object> get props => [];
}


class TermsPrivacyLoading extends TermsPrivacyState {}

class TermsPrivacyStateLoaded extends TermsPrivacyState{
  TermsPrivacyModel? termsPrivacyModel;

  TermsPrivacyStateLoaded({
    this.termsPrivacyModel,
  });

  @override
  List<Object> get props => [termsPrivacyModel!];

  // @override
  // String toString() =>
  //     'TermsPrivacySuccess { mainData: ${dataList != null ? dataList!.length : 0}, hasReachedMax: $hasReachedMax }';
}


class TermsPrivacyError extends TermsPrivacyState {
  final WEB_SERVICE_ENUM errorCode;

  const TermsPrivacyError({required this.errorCode});

  @override
  List<Object> get props => [errorCode];
}