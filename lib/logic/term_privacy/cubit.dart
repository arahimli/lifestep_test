import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/logic/term_privacy/state.dart';
import 'package:lifestep/model/static/terms_privacy.dart';
import 'package:lifestep/repositories/service/web_service.dart';
import 'package:lifestep/repositories/static.dart';



class TermsPrivacyCubit extends Cubit<TermsPrivacyState> {
  final StaticRepository staticRepository;
  TermsPrivacyModel? termsPrivacyModel;




  TermsPrivacyCubit({required this.staticRepository}) : super(TermsPrivacyLoading()) {
    this.getTermsPrivacy();
  }

  Future<bool> resetErrorTermsPrivacy({bool refresh: false}) async{
    print(state);
    if(refresh && state is TermsPrivacyError){
      print("refresh && state is TermsPrivacyError");
      emit(TermsPrivacyLoading());
      this.getTermsPrivacy();
      // times = 0;
    }
    return true;
  }

  getTermsPrivacy() async {
    print("getTermsPrivacy");
    print("listData[2]");
    List listData = await staticRepository.getTermsPrivacy();

    print("listData[2]");
    print(listData[2]);
    if(listData[2] == WEB_SERVICE_ENUM.SUCCESS) {
      TermsPrivacyResponse  termsPrivacyResponse = TermsPrivacyResponse.fromJson(listData[1]);
      emit(TermsPrivacyStateLoaded(termsPrivacyModel: termsPrivacyResponse.data));
    } else {
      emit(TermsPrivacyError(errorCode: listData[2]));
    }
  }
}
