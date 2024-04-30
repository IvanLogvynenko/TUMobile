import 'package:flutter/material.dart';
import 'package:tumobile/requests/model/client.dart';
import 'package:tumobile/schedule/view_model/schedule_data.dart';

class ClientProvider extends ChangeNotifier {
  final Client _client;

  ClientProvider() : _client = Client() {
    _init();
  }
  void _init() async {
    await _client.init();
  }

  ClientProvider.byClient(this._client);
  Future<ScheduleData> getSchedule(DateTime dateTime) async {
    return await _client.getSchedule(dateTime);
  }

  Client get client => _client;
}
