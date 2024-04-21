import 'package:flutter/material.dart';
import 'package:tumobile/api/requests/client.dart';

class ClientProvider extends ChangeNotifier {
  final Client _client;

  ClientProvider() : _client = Client();
  ClientProvider.byClient(this._client);
  Client get client => _client;
}
