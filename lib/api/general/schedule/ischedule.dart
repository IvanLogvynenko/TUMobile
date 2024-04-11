import 'package:tumobile/api/general/schedule/appointment.dart';

//wrapper that holds all appointments for a day
abstract interface class ISchedule {
  List<Appointment> get appointments;
}
