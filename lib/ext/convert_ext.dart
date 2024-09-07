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
