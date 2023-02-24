



class BottomSectionState {
  final double height;


  BottomSectionState({
    this.height = 0,
  });

  BottomSectionState copyWith({
    required double height,
  }) {
    return BottomSectionState(
      height: height,
    );
  }
}