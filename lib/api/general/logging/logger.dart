/* 
 * Supposed to be thread safe logging API
*/
import 'dart:collection';
import 'dart:io';
import 'package:mutex/mutex.dart';
import 'package:tumobile/api/general/logging/log.dart';
import 'package:tumobile/api/general/logging/logger_config.dart';
import 'package:tumobile/api/general/logging/logger_mode.dart';

class Logger {
  static Logger? _instance;

  static final Queue<Log> _messages = Queue<Log>();
  static final _queueLock = Mutex();
  static bool _shutdown = false;

  Logger._internal();

  factory Logger() {
    _instance ??= Logger._internal();
    return _instance!;
  }
  factory Logger.empty() => Logger._internal();

  void log(String message) => logLog(Log(message));
  void logLog(Log log) async  {
    await _queueLock.acquire();
    _messages.add(log);
    _queueLock.release();
  }

  Future<void> _thread() async {
    var file = File(LoggerConfiguration.logFilePath);
    while (!_shutdown) {
      await Logger._queueLock.acquire();
      while (Logger._messages.isNotEmpty) {
        if (LoggerConfiguration.writeToConsole) {
          // ignore: avoid_print
          print(Logger._messages.first.print(mode: LoggerMode.full));
        }
        if (LoggerConfiguration.writeToFile) {
          await file.writeAsString(Logger._messages.first.print());
        }
        Logger._messages.removeFirst();
      }
      Logger._queueLock.release();
    }
  }

  void start() {
    _thread();
  }

  void tryStop() {
    if (_messages.isEmpty) {
      _shutdown = true;
    }
  }

  void stop() {
    _shutdown = true;
  }

  Future<void> flush() async {
    var empty = true;
    do {
      await Logger._queueLock.acquire();
      empty = Logger._messages.isEmpty;
      Logger._queueLock.release();
      sleep(const Duration(milliseconds: 1));
    } while (!empty);
    stop();
  }
}
