import 'package:tumobile/api/general/logging/logger.dart';
import 'package:tumobile/api/general/logging/logger_mode.dart';

void main() {
  Logger logger = Logger("some path", LoggerMode.full).start();
  logger.log("some");
  logger.log("messages");
  logger.log("should");
  logger.log("appear");
  logger.log("in");
  logger.log("the");
  logger.log("file");
  logger.flush();
}
