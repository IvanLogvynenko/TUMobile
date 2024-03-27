// ignore_for_file: avoid_print

import 'package:tumobile/api/TUM/requests/tum_client.dart';
// import 'package:tumobile/api/general/requests/client.dart';

void main() async {
  TUMClient client = TUMClient();
  print("Created client");
  await client.init();
  print("Initialized client");
  print(client.session.cookies);
}
