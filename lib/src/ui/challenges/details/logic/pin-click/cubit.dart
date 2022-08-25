import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lifestep/src/ui/challenges/details/logic/pin-click/state.dart';


class PinClickCubit extends Cubit<PinClickState> {

  PinClickCubit() : super(PinClickState()){
    emit(state.copyWith(clicked: false));
  }

  toggleButton() {
      emit(state.copyWith(clicked: !state.clicked));
  }

  clickLocationActive() {
      emit(state.copyWith(clicked: true, clickedTrack: false));
  }
  clickTrackActive() {
      emit(state.copyWith(clicked: false, clickedTrack: true));
  }
  bothFalse() {
      emit(state.copyWith(clicked: false, clickedTrack: false));
  }

}