import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../lib_config.dart';
import 'model/response.dart';
import 'net_exception.dart';

class DioClient {
  static final DioClient instance = DioClient._internal();

  static final utf8decoder = Utf8Decoder();

  final Dio _dio = Dio();

  DioClient._internal() {
    _dio.options
      ..baseUrl = LibConfig.httpBaseUrl
      ..connectTimeout = 30000
      ..receiveTimeout = 10000
      ..sendTimeout = 10000;
    _dio.interceptors.addAll(LibConfig.httpInterceptors);
  }

  void clearHttpTask() {
    _dio.clear();
  }

  Future<String?> getString(String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    var response = await _dio.get(path, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onReceiveProgress: onReceiveProgress);
    if (response.statusCode == HttpStatus.ok) {
      return response.data.toString();
    }
    return null;
  }

  Future<AppResponse<T?>> postAccept<T>(String url,
      {dynamic body,
        T? Function(dynamic data)? dataDecoder,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress}) {
    return _accept(
            () =>
            _dio.post(url,
                data: body,
                queryParameters: queryParameters,
                options: options,
                cancelToken: cancelToken,
                onSendProgress: onReceiveProgress,
                onReceiveProgress: onReceiveProgress),
        dataDecoder: dataDecoder);
  }

  Future<AppResponse<T>> _accept<T>(Future<Response> Function() request, {T? Function(dynamic data)? dataDecoder}) async {
    int errorCode = -1;
    String errorMsg = "";
    try {
      var response = await request();
      errorCode = response.statusCode!;
      if (response.statusCode == HttpStatus.ok) {
        var resData = response.data;
        if (!(resData is Map<String, dynamic>)) {
          resData = jsonEncode(resData);
        }
        errorCode = resData["code"] ?? -1;
        errorMsg = resData["msg"] ?? "";
        if (errorCode == LibConfig.net_ok_code) {
          var data = resData["data"];
          return AppResponse.ok(null == dataDecoder ? data : dataDecoder(data), code: errorCode, msg: errorMsg);
        }
        LibConfig.net_error_func.call(errorCode);
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
    return AppResponse.exception(NetException(errorCode, defaultMsg: errorMsg));
  }
}
