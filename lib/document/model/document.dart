import 'package:bremind/document/model/doc.element.dart';

class ADoc {
  final String name;

  /// human readable id that can be used as route
  final String id;
  final List<DocElement> elements;

  ADoc(this.id, this.name, this.elements,);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'elements': elements.map((e) => e.toMap()).toList(),
    };
  }

  factory ADoc.fromMap(Map<String, dynamic> map) {
    return ADoc(
      map["id"],
      map['name'] as String,
      List.from(map['elements']).map((e) => DocElement.fromMap(e)).toList(),
    );
  }
}
