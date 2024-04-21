import 'dart:io';
import 'package:tumobile/api/schedule/appointment.dart';

void main() {
  Appointment.fromJSON(File("tmp/0.json").readAsStringSync());
}
