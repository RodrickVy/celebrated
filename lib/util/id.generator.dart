import 'package:uuid/uuid.dart';

class IDGenerator {
  static String generateId(int length, [String value = '']) {
    List<String> chars = (const Uuid().v4() + value + const Uuid().v1()).replaceAll('-', '').replaceAll(' ', '').split('');
    chars.shuffle();
    return chars.sublist(0, length + 1).join('');
  }
}

void main() {
  print(IDGenerator.generateId(5));
}
