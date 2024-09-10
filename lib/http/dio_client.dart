import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

class DioClient {
  static const utf8decoder = Utf8Decoder();

  final Dio _dio;

  Dio get dio => _dio;

  // final HttpClientConfig config;

  DioClient({
    String baseUrl = '',
    List<Interceptor> interceptors = const [],
    ResponseType responseType = ResponseType.json,
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
    Duration sendTimeout = const Duration(seconds: 30),
    String contentType = Headers.jsonContentType,
    String? proxy,
    ValidateStatus? validateStatus,
    ListFormat listFormat = ListFormat.multi,
    bool followRedirects = true,
    int maxRedirects = 5,
    bool receiveDataWhenStatusError = true,
    Map<String, dynamic> extra = const <String, dynamic>{},
  }) : _dio = Dio() {
    _dio.options
      ..baseUrl = baseUrl
      ..responseType = ResponseType.json
      ..contentType = contentType
      ..connectTimeout = const Duration(seconds: 60)
      ..receiveTimeout = const Duration(seconds: 60)
      ..sendTimeout = const Duration(seconds: 60)
      ..validateStatus = validateStatus ?? ((status) => (status ?? 0) < 500)
      ..followRedirects = followRedirects
      ..maxRedirects = maxRedirects
      ..receiveDataWhenStatusError = receiveDataWhenStatusError
      ..extra = extra;
    _dio.interceptors.addAll(interceptors);
    if (proxy != null) {
      // _dio.httpClientAdapter = HttpClientAdapter()..onHttpClientCreate = (client) {}
    }
  }

  Future<Response> downLoad(
    String urlPath,
    savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    data,
    Options? options,
  }) {
    return _dio.download(urlPath, savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
        options: options);
  }

  Future<String?> getString(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    var response = await get(path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
    return response.data?.toString();
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.get(path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
  }

  Future<Response<T>> post<T>(String url,
      {dynamic body,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    return _dio.post(url,
        data: body,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  Future<Response<T>> request<T>(String url,
      {dynamic body,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    return _dio.request(url,
        data: body,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);
  }

  //==================================================
  Future<String?> getHtmlString(String url,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress}) {
    return getString(url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
  }
}
