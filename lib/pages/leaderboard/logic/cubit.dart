

import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health/health.dart';
import 'package:lifestep/pages/health/logic/_tools/element.dart';
import 'package:lifestep/pages/leaderboard/logic/state.dart';
import 'package:lifestep/pages/leaderboard/tools/enum.dart';



class LeaderBoardDetailCubit extends Cubit<LeaderBoardDetailState>{
  LeaderBoardDetailCubit() : super(LeaderBoardDetailState(leaderBoardTypeEnum: LeaderBoardTypeEnum.LeaderBoardTypeStep));

  void onChangeValue(LeaderBoardTypeEnum leaderBoardTypeEnum) {
    emit(LeaderBoardDetailState(leaderBoardTypeEnum: leaderBoardTypeEnum));
  }


}