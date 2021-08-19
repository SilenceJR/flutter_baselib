import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

import '../lib_config.dart';
import 'model/response.dart';
import 'net_exception.dart';

typedef AcceptFunc<T> = Future<AppResponse<T>> Function(Future<Response> Function() request, {T? Function(dynamic data)? dataDecoder});

class HttpClientConfig {
  final String httpBaseUrl;

  final List<Interceptor> httpInterceptors;

  final AcceptFunc acceptFunc;

  final int httpSuccessCode;

  HttpClientConfig.init({required this.httpBaseUrl, required this.httpInterceptors, required this.acceptFunc, this.httpSuccessCode = 200});
}

class DioClient {
  static final utf8decoder = Utf8Decoder();

  final Dio dio;

  final HttpClientConfig config;

  DioClient()
      : dio = Dio(),
        config = LibConfig.delegate.clientConfig {
    dio.options
      ..baseUrl = config.httpBaseUrl
      ..connectTimeout = 30000
      ..receiveTimeout = 10000
      ..sendTimeout = 10000;
    dio.interceptors.addAll(config.httpInterceptors);
  }

  void clearHttpTask() {
    dio.clear();
  }

  Future<String?> getString(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    var response = await dio.get(path, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onReceiveProgress: onReceiveProgress);
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
    return config.acceptFunc.call(
        () => dio.post(url,
            data: body,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onReceiveProgress,
            onReceiveProgress: onReceiveProgress),
        dataDecoder: dataDecoder) as Future<AppResponse<T?>>;
  }
}

//defalut
Future<AppResponse<T>> defaultAccept<T>(Future<Response> Function() request, {T? Function(dynamic data)? dataDecoder, Function(int code)? netErrorFunc}) async {
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
      if (errorCode == LibConfig.delegate.clientConfig.httpSuccessCode) {
        var data = resData["data"];
        return AppResponse.ok(null == dataDecoder ? data : dataDecoder(data), code: errorCode, msg: errorMsg);
      }
      netErrorFunc?.call(errorCode);
    }
  } catch (e, s) {
    print(e);
    print(s);
  }
  return AppResponse.exception(NetExceptionDefault(errorCode, defaultMsg: errorMsg));
}
