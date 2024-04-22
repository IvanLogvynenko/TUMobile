import 'package:tumobile/api/schedule/appointment.dart';

class ScheduleData{
  List<Appointment> _appointments = List.empty(growable: true);
  final DateTime _date;

  ScheduleData(this._appointments, this._date);
  ScheduleData.empty() : _date = DateTime.now();

  List<Appointment> get appointments => _appointments;
  DateTime get date => _date;
}
