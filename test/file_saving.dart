import 'dart:io';
import 'package:tumobile/schedule/model/appointment_data.dart';

void main() {
  AppointmentData.fromJSON(File("tmp/0.json").readAsStringSync());
}
