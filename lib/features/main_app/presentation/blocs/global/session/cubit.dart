import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/data/models/config/settings.dart';
import 'package:lifestep/features/main_app/presentation/blocs/global/session/state.dart';
import 'package:lifestep/features/main_app/data/models/auth/profile.dart';
import 'package:lifestep/features/main_app/presentation/pages/user/repositories/auth.dart';
import 'package:lifestep/features/tools/config/get_it.dart';




class SessionCubit extends Cubit<SessionState> {
  final UserRepository authRepo;
  UserModel? currentUser;


  setUser(UserModel? value){
    if(value == null) {
      sl<Settings>().accessToken = '';
      sl<Settings>().accessHalfToken = '';
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
