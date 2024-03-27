import 'package:tumobile/api/general/schedule/schedule.dart';

/*
 * All functions must return a Future
 * If you don't find it necessary, you can go f*ck yourself,
 * because even if you don't use asyncronious code in your implementation, 
 * others might, so we are to do it this way.
*/
abstract interface class Client {
  Future<void> init();

  Future<void> login();
  Future<void> logout();

  Future<Schedule<T>> getCalendar<T>();

  Future<void> dispose();
}
