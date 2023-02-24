import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/features/main_app/presentation/pages/challenges/details/logic/sliding-up-panel/state.dart';


class SlidingUpCubit extends Cubit<SlidingUpState> {
  final double _initFabHeight = 90.0;

  double panelHeightOpen = 0;
  double panelHeightClosed = 0;
  double fabHeight = 120;
  final double height;




  SlidingUpCubit({required this.height}) : super(SlidingUpState()){
    panelHeightOpen =  height * 1.0 - 64 - 128;
    panelHeightClosed =  height * 4 / 10 - 64;
    fabHeight = _initFabHeight + panelHeightClosed;
    emit(state.copyWith(panelHeightOpen: panelHeightOpen, panelHeightClosed: panelHeightClosed, fabHeight: fabHeight));
  }

  changePosition(double pos) {
      fabHeight = pos * (panelHeightOpen - panelHeightClosed) + _initFabHeight + panelHeightClosed;
      emit(state.copyWith(fabHeight: fabHeight));

  }

}
