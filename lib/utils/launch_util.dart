import 'package:url_launcher/url_launcher.dart';

class LaunchUtil {
  static Future<bool> callPhone(String phone) {
    return launch("tel:$phone");
  }

  static Future<bool> sendSms(String phone) {
    return launch("sms:$phone");
  }

  static Future<bool> sendMail(String mailAddress) {
    return launch("mailto:$mailAddress");
  }
}
