import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/data/models/challenge/challenges.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/challenge/logic/bottom/state.dart';
import 'package:lifestep/features/main_app/resources/challenge.dart';


class BottomSectionCubit extends Cubit<BottomSectionState> {
  final IChallengeRepository challengeRepository;
  final ChallengeModel challengeModel;
  final double height;
  CancelToken dioToken = CancelToken();





  BottomSectionCubit( {required this.challengeRepository, required this.challengeModel, required this.height}) : super(BottomSectionState(height: height));

  Future<void> initialize() async {

  }

  changeHeight(double height) async {
    emit(BottomSectionState(height: height));
  }
}
