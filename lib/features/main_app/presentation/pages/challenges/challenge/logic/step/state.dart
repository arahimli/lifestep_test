
class StepSectionState {
  final int step;
  final String status;


  StepSectionState({
    this.step = 0,
    this.status = '?',
  });

  StepSectionState copyWith({
    required int step,
    required String status,
  }) {
    return StepSectionState(
      step: step,
      status: status,
    );
  }
}