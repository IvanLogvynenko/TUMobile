import 'dart:io';
import 'package:tumobile/schedule/model/appointment.dart';

void main() {
  Appointment.fromJSON(File("tmp/0.json").readAsStringSync());
}
