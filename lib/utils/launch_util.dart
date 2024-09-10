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

  static Future<bool> openUrl(String url) {
    return launchUrlString(url);
  }

  static Future<bool> openMap(String address) {
    return launchUrlString("geo:0,0?q=$address");
  }

  static Future<bool> openMapWithLatLng(double lat, double lng) {
    return launchUrlString("geo:$lat,$lng");
  }

  static Future<bool> checkUrl(String url) {
    return canLaunchUrlString(url);
  }
}
