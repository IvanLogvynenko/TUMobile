import 'package:tumobile/api/general/requests/session.dart';
import 'package:tumobile/api/general/schedule/schedule.dart';

abstract interface class Client {
  final Session? _session;

  Client.empty() : _session = Session.empty();

  Session get session => _session!;

  void init();

  void login();
  void logout();

  Future<Schedule<T>> getCalendar<T>();

  void dispose();
  //init
  //login
  //logout
  //get calendar
}
