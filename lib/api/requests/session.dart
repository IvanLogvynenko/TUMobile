import 'dart:io';

import 'package:tumobile/api/requests/login_status.dart';

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
    _username = value;
  }

  set password(String value) => _password = value;

  String get username => _username!;
  String get password => _password!;

  bool get credentialsProvided =>
      _username != null &&
      _password != null &&
      _username != "" &&
      _password != "";

  void close() {
    _cookies!.clear();
  }
}
