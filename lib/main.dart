import 'package:flutter/material.dart';
import 'package:tumobile/api/general/logging/logger.dart';
import 'package:tumobile/api/general/logging/logger_mode.dart';
import 'package:tumobile/api/general/requests/iclient.dart';
import 'package:tumobile/api/general/switcher/availible_universities.dart';
import 'package:tumobile/api/general/switcher/switcher.dart';
import 'package:tumobile/pages/app_body.dart';

void main() async {
  Logger logger = Logger("~", LoggerMode.full);
  logger.log("start");
  //since now it is the only university availible, let it be so
  Switcher switcher = Switcher(University.technicalUniversityMunich);
  IClient client = switcher.client;
  await client.init();

  runApp(MainApp(switcher));
}

class MainApp extends StatelessWidget {
  final Switcher switcher;

  const MainApp(this.switcher, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: AppBody(switcher));
  }
}
