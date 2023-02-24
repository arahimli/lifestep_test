import 'package:equatable/equatable.dart';
import 'package:lifestep/features/main_app/data/models/static/terms_privacy.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';

abstract class TermsPrivacyState extends Equatable {
  const TermsPrivacyState();

  @override
  List<Object> get props => [];
}


class TermsPrivacyLoading extends TermsPrivacyState {}

class TermsPrivacyStateLoaded extends TermsPrivacyState{
 final TermsPrivacyModel? termsPrivacyModel;

  const TermsPrivacyStateLoaded({
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