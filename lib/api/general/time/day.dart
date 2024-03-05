import 'package:tumobile/api/general/schedule/appointment.dart';
import 'package:tumobile/api/general/time/date.dart';
import 'package:tumobile/api/general/time/day_of_week.dart';

class Day {
  final List<Appointment> _appointments;
  final Date? _date;
  final DayOfWeek? _dayOfWeek;

  Day.empty()
      : _appointments = List.empty(growable: true),
        _date = Date.today(),
        _dayOfWeek = DayOfWeek.unstated;

  Day(this._appointments, this._date, this._dayOfWeek);

  get appointments => _appointments;
  get date => _date!;
  get dayOfWeek => _dayOfWeek!;
}
