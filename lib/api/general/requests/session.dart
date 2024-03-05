import 'dart:io';

import 'package:tumobile/api/general/requests/login_status.dart';

class Session {
  LoginStatus _loginStatus = LoginStatus.unstated;
  String? _id;

  Session.copy(Session session) {
    _loginStatus = session._loginStatus;
    _id = session._id;
  }
}
