import 'package:tumobile/api/general/logging/logger_mode.dart';

class Log {
  final String? _message;
  final DateTime? _timeOfCreation;

  Log.empty()
      : _message = null,
        _timeOfCreation = null;

  /// Please don't use this function.
  Log.setTime(this._message, this._timeOfCreation);

  /// Constructor that takes message text and creates a basic log object.
  Log(this._message) : _timeOfCreation = DateTime.now();

  String _printDate(DateTime date) =>
      '${date.hour}:${date.minute}:${date.second}';

  @override
  String toString() {
    return print();
  }

  String print({String logPath = "", LoggerMode mode = LoggerMode.full}) {
    switch (mode) {
      case LoggerMode.debug:
        return '$logPath >>> $_message!';
      case LoggerMode.full:
        return '$logPath >>> '
            '${_printDate(_timeOfCreation!)} -> ${_printDate(DateTime.now())} '
            '$_message';
      case LoggerMode.info:
        return ' >>> $_message';
      default:
        if (LoggerMode.unstated == mode) {
          return '$_message !!! > Printing in unstated mode, please configure < !!!';
        } else {
          throw Exception('Invalid LoggerMode: $mode');
        }
    }
  }
}
