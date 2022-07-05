
import 'package:equatable/equatable.dart';

class PinClickState extends Equatable{
  final bool clicked;
  final bool clickedTrack;


  PinClickState({
    this.clicked = false,
    this.clickedTrack = true,
  });

  PinClickState copyWith({
    bool? clicked,
    bool? clickedTrack,
  }) {
    return PinClickState(
      clicked: clicked != null ? clicked :  this.clicked,
      clickedTrack: clickedTrack == null ? this.clickedTrack : clickedTrack ,
    );
  }

  @override
  List<Object?> get props => [ clicked, clickedTrack ];
}