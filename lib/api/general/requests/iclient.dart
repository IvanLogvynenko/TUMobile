import 'package:tumobile/api/general/schedule/schedule.dart';
import 'package:tumobile/api/general/schedule/time_range.dart';

abstract interface class IClient {
  Future<void> init();

  Future<void> login();
  Future<void> logout();

  Future<Schedule> getCalendar<T>(DateTime dateTime,
      [TimeRange timeRange = TimeRange.day, bool showAsList = false]);

  void dispose();

  void setCredentials(String username, String password);
}
