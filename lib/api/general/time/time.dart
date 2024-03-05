class Time {
  int? _hours, _minutes;

  static bool isValid(Time time) {
    return time._hours != null &&
        time._minutes != null &&
        time._hours! >= 0 &&
        time._hours! <= 23 &&
        time._minutes! >= 0 &&
        time._minutes! <= 59;
  }

  Time.empty()
      : _hours = 0,
        _minutes = 0;
  Time.byMinutes(int minutes)
      : _hours = minutes ~/ 60,
        _minutes = minutes % 60 {
    if (!isValid(this)) {
      throw Exception("Invalid input");
    }
  }
  Time.now()
      : _hours = DateTime.now().hour,
        _minutes = DateTime.now().minute;
  Time(this._hours, this._minutes) {
    if (!isValid(this)) {
      throw Exception("Invalid input");
    }
  }

  factory Time.parse(String input) {
    var separated = input.split(':');
    return Time(int.parse(separated[0]), int.parse(separated[1]));
  }

  int get hours => _hours!;
  set hours(int value) => _hours;

  int get minutes => _minutes!;
  set minutes(int value) => _minutes;

  int toMinutes() => minutes + 60 * hours;

  Time operator +(Time time) => Time.byMinutes(toMinutes() + time.toMinutes());

  Time operator -(Time time) =>
      Time.byMinutes((toMinutes() - time.toMinutes()).abs());

  @override
  String toString() {
    return '${_hours!.toString().padLeft(2, '0')}:${_minutes!.toString().padLeft(2, '0')}';
  }
}
