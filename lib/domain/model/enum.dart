import 'package:flutter/foundation.dart';

class AnEnum<E> {
  const AnEnum();

  static E fromJson<E>(List<E> _enums, String enumString) {
    assert(_enums.isNotEmpty && enumString.isNotEmpty,
        "${E.runtimeType} does not contain key $enumString,  in ::: $_enums");
    return _enums.firstWhere(
        (element) => describeEnum(element.toString()) == enumString);
  }

  static String toJson<E>(E _enum) {
    return describeEnum(_enum.toString());
  }
}
