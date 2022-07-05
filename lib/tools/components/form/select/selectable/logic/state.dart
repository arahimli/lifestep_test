

class SelectableSelectState {
  final String? confirmedValue;
  final String? value;
  final String? display;
  final bool changed;



  SelectableSelectState({
    this.confirmedValue = '',
    this.value = '',
    this.display = '',
    this.changed = false,
  });

  SelectableSelectState copyWith({
    String? confirmedValue,
    String? value,
    String? display,
    bool? changed,
  }) {
    return SelectableSelectState(
      confirmedValue: confirmedValue ?? this.confirmedValue,
      value: value ?? this.value,
      display: display ?? this.display,
      changed: changed ?? this.changed,
    );
  }
}