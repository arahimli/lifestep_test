import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/pages/index/index/logic/leaderboard/logic/state.dart';
import 'package:lifestep/pages/leaderboard/tools/enum.dart';



class LeaderBoardHomeCubit extends Cubit<LeaderBoardHomeState>{
  LeaderBoardHomeCubit() : super(LeaderBoardHomeState(leaderBoardTypeEnum: LeaderBoardTypeEnum.LeaderBoardTypeStep));

  void onChangeValue(LeaderBoardTypeEnum leaderBoardTypeEnum) {
    emit(LeaderBoardHomeState(leaderBoardTypeEnum: leaderBoardTypeEnum));
  }


}