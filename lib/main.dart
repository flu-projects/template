import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/cupertino.dart' hide Router;
import 'package:flutter/material.dart' hide Router;
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';
// import 'package:hash/routers/pages.dart';
import 'app/routes/app_pages.dart';
import 'global.dart';
import 'utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initMothed();
  handleError(runApp(const _HashStartApp()));
}

Future<void> _initMothed() async {
  setDesignWHD(375, 812);
  await appInfo.init();
  await SpUtil.getInstance();
  await log.init();
  await Device.initDeviceInfo();
  if (Device.isAndroid) {
    Device.getAndroidSdkInt();
  }
  try {
    if (Device.isMobile) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  } catch (e) {
    log.d(e.runtimeType);
  }
}

class _HashStartApp extends StatefulWidget {
  const _HashStartApp({Key? key}) : super(key: key);

  @override
  _HashStartAppState createState() => _HashStartAppState();
}

class _HashStartAppState extends State<_HashStartApp>
    with WidgetsBindingObserver {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _subscription;

  bool _initialUriIsHandled = false;
  StreamSubscription? _sub;

  void _handleIncomingLinks() {
    if (!Device.isWeb) {
      _sub = uriLinkStream.listen((Uri? uri) {
        if (!mounted) return;
        log.d('got uri: $uri');
      }, onError: (Object err) {
        if (!mounted) return;
        log.d('got err: $err');
      });
    }
  }

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (uri != null) {
          log.d('got initial uri: $uri    ${uri.query}');
        }
      } on PlatformException {
        log.d('falied to get initial uri');
      } on FormatException catch (err) {
        if (!mounted) return;
        log.d('malformed initial uri  $err');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _handleIncomingLinks();
    _handleInitialUri();
    EventMgr.instance.init();
    _subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        // config.netWorkError = result == ConnectivityResult.none;
        if (result == ConnectivityResult.ethernet ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile) {}
      },
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription.cancel();
    _sub?.cancel();
    EventMgr.instance.destory();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.getInstance();
    return GetMaterialApp(
      title: '777Hash',
      // showPerformanceOverlay: true, //显示性能标签
      debugShowCheckedModeBanner: false, // 去除右上角debug的标签
      // checkerboardRasterCacheImages: true,
      // showSemanticsDebugger: true, // 显示语义视图
      // checkerboardOffscreenLayers: true, // 检查离屏渲染
      // home: const Application(),
      theme: _darkTheme,
      navigatorKey: navigatorKey,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.INITIAL,
      // getPages: AppPages.pages,
      // routes: AppPages.routers,
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(
          // builder: (BuildContext context, Widget? child) {
          //   if (Device.isWeb) {
          //     return MediaQuery(
          //       /// 保证文字大小不受手机系统设置影响
          //       /// https://www.kikt.top/posts/flutter/layout/dynamic-text/
          //       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          //       child: AnnotatedRegion<SystemUiOverlayStyle>(
          //         value: SystemUiOverlayStyle.dark.copyWith(
          //           statusBarColor: Colours.transparent,
          //         ),
          //         child: child ??
          //             Container(
          //               color: Colours.red,
          //               alignment: Alignment.center,
          //               child: Text(
          //                 '❌错误',
          //                 style: textBold14,
          //               ),
          //             ),
          //       ),
          //     );
          //   } else {
          //     return OfflineBuilder(
          //       child: child,
          //       connectivityBuilder: (
          //         BuildContext context,
          //         ConnectivityResult value,
          //         Widget child,
          //       ) {
          //         return Stack(
          //           children: [
          //             MediaQuery(
          //               /// 保证文字大小不受手机系统设置影响
          //               /// https://www.kikt.top/posts/flutter/layout/dynamic-text/
          //               data:
          //                   MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          //               child: AnnotatedRegion<SystemUiOverlayStyle>(
          //                 value: SystemUiOverlayStyle.dark.copyWith(
          //                   statusBarColor: Colours.transparent,
          //                 ),
          //                 child: child,
          //               ),
          //             ),
          //           ],
          //         );
          //       },
          //     );
          //   }
          // },
          ),
    );
  }

  final ThemeData _darkTheme = ThemeData(
    errorColor: red,
    brightness: Brightness.dark,
    // primaryColor: Colours.cFFD601,
    // colorScheme: const ColorScheme.dark(primary: Colours.cFFD601),
    // Tab指示器颜色
    indicatorColor: black,
    // 页面背景色
    scaffoldBackgroundColor: transparent,
    // 主要用于Material背景色
    canvasColor: transparent,

    // 文字选择色（输入框选择文字等）
    // textSelectionColor: Colours.app_main.withAlpha(70),
    // textSelectionHandleColor: Colours.app_main,
    // 稳定版：1.23 变更(https://flutter.dev/docs/release/breaking-changes/text-selection-theme)
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: black.withAlpha(70),
      selectionHandleColor: black,
      cursorColor: black,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      // color: Colours.cFFD601,
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: transparent,
      ),
    ),
    dividerTheme: const DividerThemeData(
      space: 0.6,
      thickness: 0.6,
    ),
    cupertinoOverrideTheme: const CupertinoThemeData(
      brightness: Brightness.dark,
    ),
    pageTransitionsTheme: _NoTransitionsOnWeb(),
    visualDensity: VisualDensity.standard,
    // fontFamily: 'Din_bold',
    splashColor: transparent,
    highlightColor: transparent,
  );
}

class _NoTransitionsOnWeb extends PageTransitionsTheme {
  @override
  Widget buildTransitions<T>(
    route,
    context,
    animation,
    secondaryAnimation,
    child,
  ) {
    return super.buildTransitions(
      route,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}
