import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'utils/utils.dart';

typedef ShowWindow = Function(BuildContext, dynamic);

///添加全局Controller（保存用户信息等跨页面共享数据）
class InitialBinding extends Bindings {
  GlobalLogic _logic = Get.put(
    GlobalLogic(),
    permanent: true,
  );

  @override
  void dependencies() async {
    if (Device.isMobile && !await checkServiceStatus(Permission.storage)) {
      await requestPermission(Permission.storage);
    }
  }
}

class GlobalLogic extends GetxController {
  var state = GlobalState();
}

class GlobalState {}
