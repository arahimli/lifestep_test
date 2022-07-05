class ThemeState {
  final bool dark;
  // bool get dark => language != null && language!.length > 3;



  ThemeState({
    this.dark = false,
  });

  ThemeState copyWith({
    bool? dark,
  }) {
    return ThemeState(
      dark: dark ?? this.dark,
    );
  }
}