import 'package:tumobile/api/TUM/requests/tum_client.dart';
import 'package:tumobile/api/general/logging/logger.dart';
import 'package:tumobile/api/general/logging/logger_mode.dart';

void main() async {
  Logger logger = Logger("http_client_test", LoggerMode.full).start();
  TUMClient client = TUMClient();
  logger.log("Created client");
  await client.init();
  logger.log("Initialized client");
  logger.log(await client.getNewStateWrapper());
}
