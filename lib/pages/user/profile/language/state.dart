

class LocalLanguageState {
  final String? language;
  final bool changed;
  // bool get changed => language != null && language!.length > 3;



  LocalLanguageState({
    this.language = '',
    this.changed = false,
  });

  LocalLanguageState copyWith({
    String? language,
    bool? changed,
  }) {
    return LocalLanguageState(
      language: language ?? this.language,
      changed: changed ?? this.changed,
    );
  }
}