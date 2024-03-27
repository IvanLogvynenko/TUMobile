import 'dart:io';

import 'package:tumobile/api/general/requests/login_status.dart';

base class Session {
  LoginStatus loginStatus = LoginStatus.unstated;
  String? _username, _password;
  List<Cookie>? _cookies;

  Session.empty()
      : loginStatus = LoginStatus.unstated,
        _username = null,
        _password = null,
        _cookies = null;

  Session.copy(Session session)
      : loginStatus = session.loginStatus,
        _username = session._username,
        _password = session._password;

  Session.byCreds(String username, String password)
      : loginStatus = LoginStatus.unstated,
        _username = username,
        _password = password,
        _cookies = null;

  List<Cookie> get cookies => _cookies!;
  set cookies(List<Cookie> value) => _cookies = value;

  set username(String value) {
    if (value == "") {
      throw ArgumentError("Username cannot be empty.");
    }
    if (_username == null) {
      _username = value;
    } else {
      throw ArgumentError("Username cannot be changed.");
    }
  }
  set password(String value) => _password = value;

  void setSredentials(String username, String password) {
    _username = username;
    _password = password;
  }

  void close() {
    _cookies!.clear();
  }
}
