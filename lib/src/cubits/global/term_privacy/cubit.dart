import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/cubits/global/term_privacy/state.dart';
import 'package:lifestep/src/models/static/terms_privacy.dart';
import 'package:lifestep/src/resources/service/web_service.dart';
import 'package:lifestep/src/resources/static.dart';



class TermsPrivacyCubit extends Cubit<TermsPrivacyState> {
  final IStaticRepository staticRepository;
  TermsPrivacyModel? termsPrivacyModel;




  TermsPrivacyCubit({required this.staticRepository}) : super(TermsPrivacyLoading()) {
    getTermsPrivacy();
  }

  Future<bool> resetErrorTermsPrivacy({bool refresh = false}) async{
    // print(state);
    if(refresh && state is TermsPrivacyError){
      // print("refresh && state is TermsPrivacyError");
      emit(TermsPrivacyLoading());
      getTermsPrivacy();
      // times = 0;
    }
    return true;
  }

  getTermsPrivacy() async {
    // print("getTermsPrivacy");
    // print("listData[2]");
    List listData = await staticRepository.getTermsPrivacy();

    // print("listData[2]");
    // print(listData[2]);
    if(listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
      TermsPrivacyResponse  termsPrivacyResponse = TermsPrivacyResponse.fromJson(listData[1]);
      emit(TermsPrivacyStateLoaded(termsPrivacyModel: termsPrivacyResponse.data));
    } else {
      emit(TermsPrivacyError(errorCode: listData[2]));
    }
  }
}
