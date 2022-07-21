import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Response<T> {
  final int code;
  final String message;
  final T? data;

  Response({this.code = 404, this.message = '请求失败', this.data});

  factory Response.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) =>
      _$ResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ResponseToJson(this, toJsonT);
}
