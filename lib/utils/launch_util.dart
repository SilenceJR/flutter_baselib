import 'package:url_launcher/url_launcher_string.dart';

class LaunchUtil {
  static Future<bool> callPhone(String phone) {
    return launchUrlString("tel:$phone");
  }

  static Future<bool> sendSms(String phone) {
    return launchUrlString("sms:$phone");
  }

  static Future<bool> sendMail(String mailAddress) {
    return launchUrlString("mailto:$mailAddress");
  }
}
