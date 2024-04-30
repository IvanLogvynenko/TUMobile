import 'dart:io';

import 'package:tumobile/requests/model/client.dart';
import 'package:tumobile/schedule/view_model/schedule_data.dart';

void main() async {
  Client client = Client();
  await client.init();
  await client.login();
  ScheduleData tmp = await client.getCalendar(DateTime.parse("2024-04-15"));
  int counter = 0;
  for (var element in tmp.appointments) {
    File("tmp/${counter++}.json").writeAsStringSync(element.toJSON());
  }
}
