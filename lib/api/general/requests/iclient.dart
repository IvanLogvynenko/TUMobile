import 'package:tumobile/api/general/schedule/schedule.dart';

abstract interface class IClient {
Future<void> init();

void login();
void logout();

Schedule<T> getCalendar<T>();

void dispose();

void setCredentials(String username, String password);
}
