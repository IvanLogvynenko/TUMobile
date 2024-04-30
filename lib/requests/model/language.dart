enum Language {
  german("de"),
  english("en");

  final String _value;
  const Language(this._value);
  String get value => _value;
}
