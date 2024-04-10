import 'package:tumobile/api/general/schedule/ischedule.dart';

abstract interface class IClient {
  Future<void> init();

  Future<void> login();
  Future<void> logout();

  Future<ISchedule> getCalendar<T>(DateTime dateTime);

  void dispose();

  void setCredentials(String username, String password);
}
