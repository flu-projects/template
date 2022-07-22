part of utils;

// global log class
final log = _Log._();

class _Log {
  // // 获取文档目录的路径
  late IOSink _fileSink;
  late IOSink _crashSink;
  bool _init = false;
  Future init() async {
    try {
      late Directory dir;

      if (Device.isIOS) {
        dir = await getApplicationDocumentsDirectory();
      } else if (Device.isAndroid) {
        dir = (await getExternalStorageDirectory())!;
      } else if (Device.isFuchsia) {
        dir = await getApplicationSupportDirectory();
      } else if (Device.isMacOS) {
        dir = await getApplicationSupportDirectory();
      } else if (Device.isLinux) {
        dir = await getApplicationSupportDirectory();
      } else if (Device.isWindows) {
        dir = await getApplicationSupportDirectory();
      } else {
        dir = (await getExternalStorageDirectory())!;
      }

      var path = dir.path;
      var dataStr = DateUtil.formatDate(now(), format: 'yyyy-MM-dd_HH');
      final logFile = File('$path/log_$dataStr.txt');
      _fileSink = logFile.openWrite(mode: FileMode.append, encoding: gbk);
      final crashFile = File('$path/crash_$dataStr.txt');
      _crashSink = crashFile.openWrite(mode: FileMode.append);
      _fileSink.writeln('***************************');
      _fileSink.writeln('***************************');
      _fileSink.writeln('${appInfo.version}');
      _fileSink.writeln('***************************');
      _fileSink.writeln('***************************');
      _init = true;
    } catch (e) {
      log.e('日志记录初始化：${e.runtimeType}');
    }
  }

  var printer = _MyPrinter();

  _Log._() {
    _logger = Logger(
      filter: ProductionFilter(),
      printer: printer,
    );
    Logger.level = Level.verbose;
  }

  late Logger _logger;

  void v(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool saveFile = true,
  }) {
    _logger.v(message, error, stackTrace);
    if (saveFile && _init) {
      var newMsg = printer.stringifyMessage(message);
      _fileSink.write('$newMsg\n');
    }
  }

  void d(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool saveFile = false,
  }) {
    _logger.d(message, error, stackTrace);
    if (saveFile && _init) {
      var newMsg = printer.stringifyMessage(message);
      _fileSink.write('$newMsg\n');
    }
  }

  void i(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool saveFile = false,
  }) {
    _logger.i(message, error, stackTrace);
    if (saveFile && _init) {
      var newMsg = printer.stringifyMessage(message);
      _fileSink.write('$newMsg\n');
    }
  }

  void w(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool saveFile = false,
  }) {
    _logger.w(message, error, stackTrace);
    if (saveFile && _init) {
      var newMsg = printer.stringifyMessage(message);
      _fileSink.write('$newMsg\n');
    }
  }

  void e(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool saveFile = true,
  }) {
    _logger.e(message, error, stackTrace);
    if (saveFile && _init) {
      var newMsg = printer.stringifyMessage(message);
      _fileSink.write('$newMsg\n');
    }
  }

  void writeCrash(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    var newMsg = printer.stringifyMessage(message);
    _crashSink.write('$newMsg\n error:$error\n stack:$stackTrace\n');
  }

  void wtf(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool saveFile = true,
  }) {
    _logger.wtf(message, error, stackTrace);
    if (saveFile && _init) {
      var newMsg = printer.stringifyMessage(message);
      _fileSink.write('$newMsg\n');
    }
  }

  void dirList(String date, {required ValueChanged<String> onData}) async {
    late Directory dir;
    if (Device.isIOS) {
      dir = await getApplicationDocumentsDirectory();
    } else {
      dir = (await getExternalStorageDirectory())!;
    }
    String path = dir.path;
    try {
      Stream<FileSystemEntity> files = Directory(path).list();
      await for (FileSystemEntity file in files) {
        if (!file.path.endsWith('log_$date.txt')) continue;
        var _file = File(file.path).openRead();
        String _content = '';
        _file.transform(gbk.decoder).transform(const LineSplitter()).listen(
          (event) {
            _content += event + '\n';
          },
          onDone: () {
            _content = _content.isEmpty ? '当前时间段没有记录' : _content;
            onData(_content);
          },
        );
      }
    } catch (e) {
      print('======    失败    $e');
    }
  }
}

class _MyPrinter extends SimplePrinter {
  @override
  List<String> log(LogEvent event) {
    var messageStr = stringifyMessage(event.message);
    var errorStr = event.error != null ? '  ERROR: ${event.error}' : '';
    var timeStr = printTime ? 'TIME: ${DateTime.now().toIso8601String()}' : '';
    return ['${_labelFor(event.level)} $timeStr $messageStr$errorStr'];
  }

  String stringifyMessage(dynamic msg) {
    return (_getTime() + msg.toString());
  }

  String _labelFor(Level level) {
    var prefix = SimplePrinter.levelPrefixes[level]!;
    var color = SimplePrinter.levelColors[level]!;

    return colors ? color(prefix) : prefix;
  }

  String _getTime() {
    String _threeDigits(int n) {
      if (n >= 100) return '$n';
      if (n >= 10) return '0$n';
      return '00$n';
    }

    String _twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    var now = DateTime.now();
    var h = _twoDigits(now.hour);
    var min = _twoDigits(now.minute);
    var sec = _twoDigits(now.second);
    var ms = _threeDigits(now.millisecond);

    return '[$h:$min:$sec.$ms] ';
  }
}
