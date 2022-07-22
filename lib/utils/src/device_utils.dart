part of utils;

class Device {
  static bool get isDesktop => !isWeb && (isWindows || isLinux || isMacOS);
  static bool get isMobile => isAndroid || isIOS;
  static bool get isWeb => kIsWeb;

  static bool get isWindows => !isWeb && Platform.isWindows;
  static bool get isLinux => !isWeb && Platform.isLinux;
  static bool get isMacOS => !isWeb && Platform.isMacOS;
  static bool get isAndroid => !isWeb && Platform.isAndroid;
  static bool get isFuchsia => !isWeb && Platform.isFuchsia;
  static bool get isIOS => !isWeb && Platform.isIOS;

  static late AndroidDeviceInfo _androidInfo;
  static late IosDeviceInfo _iosInfo;
  static late WebBrowserInfo _browserInfo;

  static bool get isMobileWeb => isAndroidWeb || isIosWeb;

  static bool get isAndroidWeb => () {
        if (isWeb) {
          var _temp = Device.web.userAgent?.toUpperCase();
          return _temp?.contains('ANDROID') ?? false;
        } else {
          return false;
        }
      }();

  static bool get isIosWeb => () {
        if (isWeb) {
          var _temp = Device.web.userAgent?.toUpperCase();
          return _temp?.contains('IPHONE') ?? false;
        } else {
          return false;
        }
      }();

  static Future<void> initDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (isAndroid) {
      _androidInfo = await deviceInfo.androidInfo;
    } else if (isIOS) {
      _iosInfo = await deviceInfo.iosInfo;
    } else {
      _browserInfo = await deviceInfo.webBrowserInfo;
    }
  }

  /// 使用前记得初始化
  static int getAndroidSdkInt() {
    if (isAndroid) {
      return _androidInfo.version.sdkInt ?? -1;
    } else {
      return -1;
    }
  }

  static String infos() {
    // if (Constant.isDriverTest) {
    //   return '';
    // }
    if (isAndroid) {
      return '${_androidInfo.fingerprint}/${_androidInfo.androidId}';
    } else if (isIOS) {
      return _iosInfo.identifierForVendor ?? '';
    } else {
      return _browserInfo.userAgent ?? '';
    }
  }

  static String brand() {
    if (isAndroid) {
      return _androidInfo.brand ?? '';
    } else if (isIOS) {
      return _iosInfo.name!;
    } else {
      return _browserInfo.productSub ?? '';
    }
  }

  static AndroidDeviceInfo get android => _androidInfo;

  static IosDeviceInfo get ios => _iosInfo;

  static WebBrowserInfo get web => _browserInfo;
}
