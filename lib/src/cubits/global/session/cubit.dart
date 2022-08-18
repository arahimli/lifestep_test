import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/tools/config/endpoints.dart';
import 'package:lifestep/src/cubits/global/session/state.dart';
import 'package:lifestep/src/models/auth/profile.dart';
import 'package:lifestep/src/ui/user/repositories/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SessionCubit extends Cubit<SessionState> {
  final UserRepository authRepo;
  UserModel? currentUser;


  setUser(UserModel? value){
    //////// print("setUser(User? value) {");
    //////// print(value);
    if(value == null) {
      TOKEN = '';
      HALF_TOKEN = '';
      SharedPreferences.getInstance().then((pref){
        pref.remove('token');
      });
    }
    emit(SessionState(currentUser: value));
    currentUser = value;
  }


  resetUser() {
    emit(SessionState(currentUser: null));
  }

  SessionCubit({required this.authRepo}) : super(SessionState()) {
    attemptAutoLogin();
  }

  Future<void> attemptAutoLogin() async {

  }
  Future<List> logout() async {
    return authRepo.logoutUser();
  }
  Future<List> deleteUser() async {
    return authRepo.deleteUser(
      data: {}
    );
  }
}
