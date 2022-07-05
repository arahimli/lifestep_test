import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/tools/common/validator.dart';
import 'package:lifestep/config/endpoints.dart';
import 'package:lifestep/model/challenge/challenges.dart';
import 'package:lifestep/model/donation/fonds.dart';
import 'package:lifestep/pages/challenges/challenge/logic/bottom/state.dart';
import 'package:lifestep/pages/donations/details/fond/logic/donate/state.dart';
import 'package:lifestep/repositories/challenge.dart';
import 'package:lifestep/repositories/donation.dart';


class BottomSectionCubit extends Cubit<BottomSectionState> {
  final ChallengeRepository challengeRepository;
  final ChallengeModel challengeModel;
  final double height;
  CancelToken dioToken = CancelToken();





  BottomSectionCubit( {required this.challengeRepository, required this.challengeModel, required this.height}) : super(BottomSectionState(height: height)) {

  }

  Future<void> initialize() async {

  }

  changeHeight(double height) async {
    emit(BottomSectionState(height: height));
  }
}
