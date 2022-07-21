import 'package:dio/dio.dart';

const receiveTimeout = 5000;

class DioUtil {
  // 静态变量指向自身
  static final DioUtil _instance = DioUtil._();
  // final _iv = IV.fromLength(16);
  // final _encrypter = Encrypter(AES(
  //   Key.fromUtf8('HASH_18888-LUCK@'),
  //   mode: AESMode.ecb,
  // ));

  // 私有构造器
  DioUtil._();

  // 方案1：静态方法获得实例变量
  static DioUtil getInstance() => _instance;

  // 方案2：工厂构造方法获得实例变量
  factory DioUtil() => _instance;

  // 方案3：静态属性获得实例变量
  static DioUtil get instance => _instance;
  int _count = 0;

  Dio createDioInstance() {
    var dio = Dio(BaseOptions(
      connectTimeout: receiveTimeout,
      sendTimeout: receiveTimeout,
      receiveTimeout: receiveTimeout,
    ));

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Content-Type'] = 'application/json';
          options.headers['accept'] = 'application/json, text/plain, */*';
          options.headers['Access-Control_Allow_Origin'] = '*';
          // if (config.encrypt && options.path != '/user/shareBindDevice/') {
          //   var _data = _encrypter.encrypt(
          //     json.encode(options.data),
          //     iv: _iv,
          //   );
          //   options.data = _data.base64;
          // }
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          // if (config.encrypt) {
          //   if (response.requestOptions.path != '/user/shareBindDevice/') {
          //     var _data = _encrypter.decrypt(
          //       Encrypted.fromBase64(response.data.toString()),
          //       iv: _iv,
          //     );
          //     response.data = json.decode(_data);
          //   }
          // }
          _count = 0;
          return handler.next(response);
        },
        onError: (DioError e, handler) async {
          if (e.response != null) {
            if (e.response!.statusCode == 403) {
              _count = 0;
              _errorHandle(e: e, handler: handler);
            } else {
              _errorHandle(e: e, handler: handler);
            }
          } else {
            _errorHandle(e: e, handler: handler);
          }
        },
      ),
    );
    return dio;
  }

  void _errorHandle({
    required DioError e,
    required ErrorInterceptorHandler handler,
  }) async {
    RequestOptions requestOptions = e.requestOptions;
    int statusCode = e.response?.statusCode ?? 400;
    String msg = e.message;
    if (e.type == DioErrorType.receiveTimeout) {
      statusCode = 1000;
      msg = '网络繁忙，请稍后重试';
    }
    handler.resolve(Response(
      statusCode: statusCode,
      statusMessage: msg,
      requestOptions: requestOptions,
    ));
  }
}
