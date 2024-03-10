import 'package:tumobile/api/general/schedule/appointment.dart';
import 'package:tumobile/api/general/schedule/time_range.dart';

class Day {
  final List<Appointment> _appointments;
  final DateTime? _date;
  static const TimeRange timeRange = TimeRange.day;

  Day.empty()
      : _appointments = List.empty(growable: true),
        _date = DateTime.now();

  Day(this._appointments, this._date);

  get appointments => _appointments;
  get date => _date!;
}
