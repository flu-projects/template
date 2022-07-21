import 'package:dio/dio.dart' hide Response;
import 'package:retrofit/http.dart';
import 'package:wallet/models/index.dart';
import 'package:wallet/network/src/response.dart';

import 'dioutil.dart';

part 'api.g.dart';

Api http = Api(
  DioUtil.instance.createDioInstance(),
  baseUrl: '',
);

@RestApi(baseUrl: '')
abstract class Api {
  factory Api(Dio dio, {String baseUrl}) = _Api;

  @POST('/api/v1/login')
  Future<Response<User>> login();
}
