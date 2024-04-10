import 'dart:io';

import 'package:tumobile/api/TUM/requests/tum_client.dart';
import 'package:tumobile/api/general/logging/logger.dart';
import 'package:tumobile/api/general/logging/logger_mode.dart';
import 'package:tumobile/api/general/schedule/ischedule.dart';

void main() async {
  Logger logger = Logger("http_client_test", LoggerMode.full).start();
  TUMClient client = TUMClient();
  logger.log("Created client");
  await client.init();
  logger.log("Initialized client");
  client.setCredentials(/**/);
  await client.login();
  ISchedule sch = await client.getCalendar(DateTime.parse("20240415"));
  File file = File("tmp/index.html");
}
