import 'package:tumobile/api/general/schedule/appointment.dart';

//wrapper that holds all appointments for a day
interface class ISchedule {
  DateTime date = DateTime.now();

  List<Appointment> _appointments = List<Appointment>.empty(growable: true);

  ISchedule.empty();
}
