enum TimeRange {
  day('t'),
  week('w');

  final String _value;

  const TimeRange(this._value);

  String get value => _value;
}
