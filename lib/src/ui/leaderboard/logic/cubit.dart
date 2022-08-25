
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/ui/leaderboard/logic/state.dart';
import 'package:lifestep/src/ui/leaderboard/tools/enum.dart';



class LeaderBoardDetailCubit extends Cubit<LeaderBoardDetailState>{
  LeaderBoardDetailCubit() : super(LeaderBoardDetailState(leaderBoardTypeEnum: LeaderBoardTypeEnum.leaderBoardTypeStep));

  void onChangeValue(LeaderBoardTypeEnum leaderBoardTypeEnum) {
    emit(LeaderBoardDetailState(leaderBoardTypeEnum: leaderBoardTypeEnum));
  }


}