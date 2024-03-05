import 'package:tumobile/api/general/requests/login_status.dart';

base class Session {
  LoginStatus _loginStatus = LoginStatus.loggedOut;
  String? _login, _password;

  Session.empty()
      : _loginStatus = LoginStatus.unstated,
        _login = "",
        _password = "";

  Session.copy(Session session) {
    _loginStatus = session._loginStatus;
    _login = session._login;
    _password = session._password;
  }
}
