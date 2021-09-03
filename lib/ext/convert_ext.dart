import 'dart:convert';
import 'dart:developer';

export 'dart:convert';

extension MapExt on Map {
  String? getString(dynamic key, {String? defValue, bool noNull = true}) {
    var value = this[key];
    if (null != value) {
      if (value is String) {
        return value;
      }
      return value.toString();
    }
    return defValue ?? (noNull ? "" : null);
  }

  bool? getBoolean(dynamic key, {bool? defValue, bool noNull = true}) {
    var value = this[key];
    if (null != value) {
      if (value is bool) {
        return value;
      }
      if (value is int) {
        return value == 1;
      }
      var v = value.toString().toLowerCase();
      return v == "1" || v == "true";
    }
    return defValue ?? (noNull ? false : null);
  }

  int? getInt(dynamic key, {int? defValue, bool noNull = true}) {
    var value = this[key];
    if (null != value) {
      if (value is int) {
        return value;
      }
      if (value is String) {
        return int.tryParse(value) ?? (noNull ? 0 : null);
      }
      return int.tryParse(value.toString()) ?? (noNull ? 0 : null);
    }
    return defValue ?? (noNull ? 0 : null);
  }

  double? getDouble(dynamic key, {double? defValue, bool noNull = true}) {
    var value = this[key];
    if (null != value) {
      if (value is double) {
        return value;
      }
      if (value is String) {
        return (double.tryParse(value) ?? (noNull ? 0 : null));
      }
      return double.tryParse(value.toString()) ?? (noNull ? 0 : null);
    }
    return defValue ?? (noNull ? 0 : null);
  }

  T? getObject<T>(dynamic key, {T? Function(dynamic value)? decoder}) {
    var value = this[key];
    if (null != value) {
      if (value is T) {
        return value;
      }
      return decoder?.call(value);
    }
    return null;
  }
}

tryCatch(Function function) {
  try {
    function.call();
  } catch (s) {
    print(s.toString());
  }
}

T? asT<T>(dynamic value, [T? defaultValue]) {
  if (value is T) {
    return value;
  }
  if (value != null) {
    try {
      final String valueS = value.toString();
      if ('' is T) {
        return valueS as T;
      } else if (0 is T) {
        return int.parse(valueS) as T;
      } else if (0.0 is T) {
        return double.parse(valueS) as T;
      } else if (false is T) {
        return (valueS == '1' || valueS == 'true') as T;
      } else {
        return json.decode(value.toString()) as T?;
      }
    } catch (e, s) {
      log('asT<$T>', error: e, stackTrace: s);
      if (0 is T) {
        return defaultValue ?? 0 as T;
      } else if (0.0 is T) {
        return defaultValue ?? 0.0 as T;
      } else if (false is T) {
        return defaultValue ?? false as T;
      }
    }
  } else {
    if ('' is T) {
      return defaultValue ?? "" as T;
    } else if (0 is T) {
      return defaultValue ?? 0 as T;
    } else if (0.0 is T) {
      return defaultValue ?? 0.0 as T;
    } else if (false is T) {
      return defaultValue ?? false as T;
    }
  }
  return defaultValue ?? null;
}
