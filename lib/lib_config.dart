import 'http/http_client.dart';

class LibConfig {
  static ConfigDelegate delegate = throw Exception("not init config");
}

abstract class ConfigDelegate {
  bool get debugEnable;

  HttpClientConfig get clientConfig;
}
