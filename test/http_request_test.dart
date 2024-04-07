import 'dart:io';

import 'package:tumobile/api/TUM/requests/tum_client.dart';
import 'package:tumobile/api/general/logging/logger.dart';
import 'package:tumobile/api/general/logging/logger_mode.dart';
import 'package:tumobile/api/general/schedule/schedule.dart';

void main() async {
  Logger logger = Logger("http_client_test", LoggerMode.full).start();
  TUMClient client = TUMClient();
  logger.log("Created client");
  await client.init();
  logger.log("Initialized client");
  client.setCredentials("go98tug", "21!Lnva1204");
  await client.login();
  Schedule sch = await client.getCalendar(DateTime.parse("20240404"));
  File file = File("tmp/index.html");
  file.writeAsString(sch.data);
}
