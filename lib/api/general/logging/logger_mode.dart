enum LoggerMode {
  full(),
  debug(1),
  info(2),
  unstated(3);

  final int _value;
  const LoggerMode([this._value = 0]);
  int get value => _value;
}
