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

  String? _path;
  LoggerMode _mode = LoggerMode.unstated;
  Logger._internal(this._path, this._mode);

  factory Logger([String? path, LoggerMode mode = LoggerMode.unstated]) {
    _instance ??= Logger._internal(path, mode);
    return _instance!;
  }
  factory Logger.empty() => Logger._internal(null, LoggerMode.unstated);

  // ignore: avoid_print
  void log(String message) => print(Log(message)
      .print(logPath: _path != null ? _path! : " >>> ", mode: _mode));
  // void log(String message) => logLog(Log(message));
  void logLog(Log log) async {
    await _queueLock.acquire();
    _messages.add(log);
    _queueLock.release();
  }

  Future<void> _thread() async {
    var file = File(LoggerConfiguration.logFilePath);
    while (!_shutdown) {
      await _queueLock.acquire();
      while (_messages.isNotEmpty) {
        String logOutput = _messages
            .removeFirst()
            .print(logPath: _path != null ? _path! : " >>> ", mode: _mode);

        if (LoggerConfiguration.writeToConsole) {
          // ignore: avoid_print
          print(logOutput);
        }
        if (LoggerConfiguration.writeToFile) {
          await file.writeAsString(logOutput);
        }
      }
      _queueLock.release();
    }
  }

  Logger start() {
    _thread();
    return this;
  }

  void tryStop() {
    if (_messages.isEmpty) {
      _shutdown = true;
    }
  }

  void stop() {
    _shutdown = true;
  }

  void flush() async {
    while (true) {
      await _queueLock.acquire();
      if (_messages.isEmpty) break;
      _queueLock.release();
    }
    stop();
  }
}
