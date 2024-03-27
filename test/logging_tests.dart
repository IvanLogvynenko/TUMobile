import 'package:tumobile/api/general/logging/logger.dart';

void main() async {
  Logger logger = Logger();
  logger.log("some");
  logger.log("messages");
  logger.log("should");
  logger.log("appear");
  print("starting logger");
  logger.start();
  logger.log("in");
  logger.log("the");
  logger.log("file");
  await logger.flush();
}
