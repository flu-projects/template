part of utils;

/// 捕获全局异常，进行统一处理。
void handleError(void body) {
  /// 重写Flutter异常回调 FlutterError.onError
  FlutterError.onError = (FlutterErrorDetails details) {
    if (!Constant.inProduction) {
      // debug时，直接将异常信息打印。
      FlutterError.dumpErrorToConsole(details);
    } else {
      // release时，将异常交由zone统一处理。
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  /// 使用runZonedGuarded捕获Flutter未捕获的异常
  runZonedGuarded(() => body, (Object error, StackTrace stackTrace) async {
    await _reportError(error, stackTrace);
  }, zoneValues: {}, zoneSpecification: const ZoneSpecification());
}

Future<void> _reportError(Object error, StackTrace stackTrace) async {
  if (!Constant.inProduction) {
    debugPrintStack(
      stackTrace: stackTrace,
      label: error.toString(),
      maxFrames: 100,
    );
  } else {
    // FlutterBugly.postCatchedException(() => error);
  }
}
