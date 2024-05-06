import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    // TODO: implement caching and file saving logic
    return await _client.getSchedule(dateTime);
  }

  Future<String> getUsername() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("nickname")) {
      return prefs.getString("nickname")!;
    } else {
      String username = await _client.getUsername();
      prefs.setString("nickname", username);
      return username;
    }
  }

  //TODO: remove this so that this provider is a full wrapper
  Client get client => _client;
}
