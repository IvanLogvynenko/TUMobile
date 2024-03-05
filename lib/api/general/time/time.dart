class Time {
  int? _hours, _minutes;

  Time()
      : _hours = 0,
        _minutes = 0;

  Time.byMinutes(int minutes)
      : _hours = minutes ~/ 60,
        _minutes = minutes % 60;

  Time.full(this._hours, this._minutes);

  int getHours() {
    return _hours!;
  }

  int getMinutes() {
    return _minutes!;
  }

  factory Time.parse(String input) {
    var separated = input.split(':');
    return Time.full(int.parse(separated[0]), int.parse(separated[1]));
  }

  Time afterAMinute(Function() callback) {
    if (_minutes == 0) {
      _hours = _hours! - 1;
      _minutes = 59;
    } else {
      _minutes = _minutes! - 1;
    }
    return this;
  }

  int getDifferenceInMinutes(Time future) {
    return (future.getHours() - _hours!) * 60 +
        (future.getMinutes() - _minutes!);
  }
}
