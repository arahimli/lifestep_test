import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/presentation/pages/index/logic/leaderboard/logic/state.dart';
import 'package:lifestep/features/main_app/presentation/pages/leaderboard/tools/enum.dart';



class LeaderBoardHomeCubit extends Cubit<LeaderBoardHomeState>{
  LeaderBoardHomeCubit() : super(LeaderBoardHomeState(leaderBoardTypeEnum: LeaderBoardTypeEnum.leaderBoardTypeStep));

  void onChangeValue(LeaderBoardTypeEnum leaderBoardTypeEnum) {
    emit(LeaderBoardHomeState(leaderBoardTypeEnum: leaderBoardTypeEnum));
  }


}