import 'package:dio/dio.dart';

import '../../main.dart';

class ApiResponseModel {
  Map<String, dynamic>? data;
  final Response response;
  bool success = false;
  String? message;

  ApiResponseModel({
    required this.response,
  }) {
    try {
      data = response.data;
    } catch (e, s) {
      print("$e, $s");    }
    try {
      success = ((response.data["success"] ?? response.data["status"]) ?? false);
    } catch (e, s) {
      print("$e, $s");    }
    try {
      message = (data?["message"] ?? data?["msg"]);
    } catch (e, s) {
      print("$e, $s");
    }
  }
}
