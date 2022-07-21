// part of http;
import 'package:json_annotation/json_annotation.dart';

part 'request.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Request<T> {
  final String token;
  final T? data;

  Request({this.token = '', this.data});

  factory Request.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) =>
      _$RequestFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$RequestToJson(this, toJsonT);
}
