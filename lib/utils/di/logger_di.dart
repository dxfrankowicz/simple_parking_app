import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' as foundation;

@module
abstract class LoggerDi {
  @lazySingleton
  Logger getLogger() => Logger(
      printer: foundation.kReleaseMode
          ? SimplePrinter(printTime: true)
          : PrettyPrinter(methodCount: 3),
      filter: CrashlyticsFilter(),
      level: Level.verbose,
      output: CrashlyticsOutput(ConsoleOutput()));
}

class CrashlyticsOutput extends LogOutput {
  LogOutput _delegatedOutput;

  CrashlyticsOutput(this._delegatedOutput);

  @override
  void output(OutputEvent event) {
    _delegatedOutput.output(event);
  }
}

class CrashlyticsFilter extends LogFilter {

  CrashlyticsFilter();

  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
