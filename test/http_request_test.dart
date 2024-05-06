// ignore_for_file: avoid_print

import 'package:tumobile/requests/model/client.dart';

void main() async {
  Client client = Client();
  await client.init();
  await client.login();
  await client.logout();
}
