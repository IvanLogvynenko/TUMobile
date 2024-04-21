import 'package:tumobile/api/schedule/appointment.dart';
import 'package:tumobile/api/schedule/ischedule.dart';

class TUMSchedule implements ISchedule {
  List<Appointment> _appointments = List.empty(growable: true);
  DateTime? _date;

  TUMSchedule(this._appointments, this._date);
  TUMSchedule.empty() : _date = DateTime.now();
  // TUMSchedule.fromListOfAppointments();

  @override
  List<Appointment> get appointments => _appointments;
  DateTime get date => _date!;
}
