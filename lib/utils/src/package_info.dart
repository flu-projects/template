part of utils;

var appInfo = _AppInfo();

class _AppInfo {
  // static AppInfo _appInfo = AppInfo._();
  // factory AppInfo() => _appInfo;
  // AppInfo._();

  PackageInfo? _packageInfo;
  Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  String get appName => _packageInfo?.appName ?? '777Hash';
  String get packageName => _packageInfo?.packageName ?? 'com.star.hash';
  Version get version => Version.parse(_packageInfo?.version ?? '1.0.0');
  String get buildNumber => _packageInfo?.buildNumber ?? '100';
  String description = '';
  bool force = false;
}
