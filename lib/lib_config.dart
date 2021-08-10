import 'package:dio/dio.dart';

class LibConfig {
  static String httpBaseUrl = "";

  static bool degbuEnable = true;

//http拦截器
  static List<Interceptor> httpInterceptors = <Interceptor>[];

//服务器返回成功code
  static int net_ok_code = 200;

//网络请求数据失败
  static Function(int code) get net_error_func => (int code) {};
}
