import 'package:bremind/domain/model/content.dart';
import 'package:bremind/document/model/doc.element.type.dart';

class DocElement extends Content {
  final DocElType type;
  final String value;

  DocElement(this.type, this.value);

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'value': value,
    };
  }

  factory DocElement.fromMap(Map<String, dynamic> map) {
    return DocElement(
      DocElType.values.byName(map['type']),
      map['value'],
    );
  }
}
