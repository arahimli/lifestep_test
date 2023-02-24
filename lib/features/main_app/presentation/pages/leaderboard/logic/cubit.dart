
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/presentation/pages/leaderboard/logic/state.dart';
import 'package:lifestep/features/main_app/presentation/pages/leaderboard/tools/enum.dart';



class LeaderBoardDetailCubit extends Cubit<LeaderBoardDetailState>{
  LeaderBoardDetailCubit() : super(LeaderBoardDetailState(leaderBoardTypeEnum: LeaderBoardTypeEnum.leaderBoardTypeStep));

  void onChangeValue(LeaderBoardTypeEnum leaderBoardTypeEnum) {
    emit(LeaderBoardDetailState(leaderBoardTypeEnum: leaderBoardTypeEnum));
  }


}