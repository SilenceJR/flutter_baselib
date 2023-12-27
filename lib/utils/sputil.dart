import 'package:get_storage/get_storage.dart';

class SPUtil {
  SPUtil._();

  static SPUtil? _instance;

  static SPUtil get instance => _instance ??= SPUtil._();

  static final _configName = "AppPref";

  static final GetStorage _box = GetStorage(_configName);

  static Future<bool> init() async {
    return await GetStorage.init(_configName);
  }

  T? get<T>(String key) {
    return _box.read<T>(key);
  }

  Future<void> put(String key, dynamic value) async {
    return await _box.write(key, value);
  }

  bool contains(String key) {
    return _box.hasData(key);
  }

  listenKey(String key, Function(dynamic) callback) {
    _box.listenKey(key, callback);
  }

  Future<void> remove(String key) async {
    return await _box.remove(key);
  }

  Future<void> clearAll() async {
    return await _box.erase();
  }
}
