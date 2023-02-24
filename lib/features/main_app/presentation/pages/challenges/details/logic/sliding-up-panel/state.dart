
class SlidingUpState {
  final double panelHeightOpen;
  final double panelHeightClosed;
  final double fabHeight;


  SlidingUpState({
    this.panelHeightOpen = 0,
    this.panelHeightClosed = 0,
    this.fabHeight = 0,
  });

  SlidingUpState copyWith({
    double? panelHeightOpen,
    double? panelHeightClosed,
    double? fabHeight,
  }) {
    return SlidingUpState(
      panelHeightOpen: panelHeightOpen ?? this.panelHeightOpen,
      panelHeightClosed: panelHeightClosed ?? this.panelHeightClosed,
      fabHeight: fabHeight ?? this.fabHeight,
    );
  }
}