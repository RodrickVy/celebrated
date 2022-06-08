import 'package:flutter/foundation.dart';

class EnumSerialize {
  static T fromJson<T>(List<T> values, String string) {
    try {
      return values.firstWhere(
          (T element) => describeEnum(element!).toLowerCase() == string);
    } catch (_) {
      return values.first;
    }
  }

  static String toJson<T>(T value) {
    return describeEnum(value!);
  }
}
