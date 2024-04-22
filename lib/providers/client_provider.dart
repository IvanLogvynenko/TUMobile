import 'package:flutter/material.dart';
import 'package:tumobile/api/requests/client.dart';

class ClientProvider extends ChangeNotifier {
  final Client _client;

  ClientProvider() : _client = Client() {
    _init();
  }
  void _init() async {
    await _client.init();
  }

  ClientProvider.byClient(this._client);
  Client get client => _client;
}
