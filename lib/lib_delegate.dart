import 'package:dio/dio.dart';

String get httpBaseUrl => "";

bool get degbuEnable => true;

//http拦截器
List<Interceptor> httpInterceptors = <Interceptor>[];

//服务器返回成功code
int get net_ok_code => 200;

//网络请求数据失败
Function(int code) get net_error_func => (int code) {};
