
import 'package:equatable/equatable.dart';

class PinClickState extends Equatable{
  final bool clicked;
  final bool clickedTrack;


  const PinClickState({
    this.clicked = false,
    this.clickedTrack = true,
  });

  PinClickState copyWith({
    bool? clicked,
    bool? clickedTrack,
  }) {
    return PinClickState(
      clicked: clicked ?? this.clicked,
      clickedTrack: clickedTrack ?? this.clickedTrack,
    );
  }

  @override
  List<Object?> get props => [ clicked, clickedTrack ];
}