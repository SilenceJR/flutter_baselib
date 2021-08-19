import 'http/http_client.dart';

class LibConfig {
  static ConfigDelegate delegate = throw Exception("not init config");
}

abstract class ConfigDelegate {
  bool debugEnable;

  HttpClientConfig clientConfig;

  ConfigDelegate.init({this.debugEnable = true, required this.clientConfig});
}
