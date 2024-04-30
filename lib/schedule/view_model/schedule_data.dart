import 'package:tumobile/schedule/model/appointment_data.dart';

class ScheduleData {
  List<AppointmentData> _appointments = List.empty(growable: true);
  final DateTime _date;

  ScheduleData(this._appointments, this._date);
  ScheduleData.empty() : _date = DateTime.now();

  List<AppointmentData> get appointments => _appointments;
  DateTime get date => _date;
}
