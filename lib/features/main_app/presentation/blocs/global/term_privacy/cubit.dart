import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/term_privacy/state.dart';
import 'package:lifestep/features/main_app/data/models/static/terms_privacy.dart';
import 'package:lifestep/features/main_app/resources/service/web_service.dart';
import 'package:lifestep/features/main_app/resources/static.dart';



class TermsPrivacyCubit extends Cubit<TermsPrivacyState> {
  final IStaticRepository staticRepository;
  TermsPrivacyModel? termsPrivacyModel;




  TermsPrivacyCubit({required this.staticRepository}) : super(TermsPrivacyLoading()) {
    getTermsPrivacy();
  }

  Future<bool> resetErrorTermsPrivacy({bool refresh = false}) async{
    if(refresh && state is TermsPrivacyError){
      emit(TermsPrivacyLoading());
      getTermsPrivacy();
    }
    return true;
  }

  getTermsPrivacy() async {
    List listData = await staticRepository.getTermsPrivacy();

    if(listData[2] == WEB_SERVICE_ENUM.success) {
      TermsPrivacyResponse  termsPrivacyResponse = TermsPrivacyResponse.fromJson(listData[1]);
      emit(TermsPrivacyStateLoaded(termsPrivacyModel: termsPrivacyResponse.data));
    } else {
      emit(TermsPrivacyError(errorCode: listData[2]));
    }
  }
}
