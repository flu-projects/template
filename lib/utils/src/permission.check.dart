part of utils;
//Permission.ignoreBatteryOptimizations    忽略电池优化
//Permission.systemAlertWindow   允许在其他应用之上
//Permission.accessNotificationPolicy  免打扰

Future<bool> checkServiceStatus(Permission permission) async {
  bool ret = false;
  if (permission is PermissionWithService) {
    switch (await permission.serviceStatus) {
      case ServiceStatus.enabled:
        ret = true;
        break;
      default:
    }
  } else {
    switch (await permission.status) {
      case PermissionStatus.granted:
        ret = true;
        break;
      case PermissionStatus.limited:
        if (Device.isIOS) {
          ret = true;
        }
        break;
      default:
    }
  }
  return ret;
}

Future<PermissionStatus> requestPermission(Permission permission) async {
  return await permission.request();
}

void permission(Permission permission) async {
  if (!await checkServiceStatus(permission)) {
    requestPermission(permission);
  }
}
