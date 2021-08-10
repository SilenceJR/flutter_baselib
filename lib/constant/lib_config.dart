import 'package:dio/dio.dart';

class LibConfig {
  static String get httpBaseUrl => throw Exception("not imp");

  static bool get degbuEnable => throw Exception("not imp");

  //http拦截器
  static List<Interceptor> httpInterceptors = <Interceptor>[];

  //服务器返回成功code
  static int get net_ok_code => 200;

  //网络请求数据失败
  static  Function(int code) get net_error_func => (int code){};
}
