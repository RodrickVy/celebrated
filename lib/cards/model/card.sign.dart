import 'package:get/get.dart';

class CardSign {
  final String id;
  final Map<String, SignatureElement> _elements;

  Map<String, SignatureElement> get elements => _elements;

  CardSign({required this.id, required final List<SignatureElement> elements})
      : _elements = Map.fromIterable(elements, key: (value) => value.id, value: (value) => value);

  Map<String, dynamic> toMap() {
    return {
      'elements': _elements.values.map((e) => e.toMap()).toList(),
      'id': id,
    };
  }

  factory CardSign.fromMap(Map<String, dynamic> map) {
    return CardSign(
        elements: List.from(map['elements']).map((e) => SignatureElement.fromMap(e)).toList(), id: map['id']);
  }

  CardSign copyWith({
    String? id,
    List<SignatureElement>? elements,
  }) {
    return CardSign(
      id: id ?? this.id,
      elements: elements ?? _elements.values.toList(),
    );
  }

  CardSign withElement(SignatureElement element) {
    _elements[element.id] =  element;
    return this;
  }

  CardSign removeElement(SignatureElement element) {
    _elements.remove(element.id);
    return this;
  }
}

enum SigElementType { text,  gif }

class SignatureElement {
  final SigElementType type;
  final String id;
  final String value;
  final Map<String, dynamic> metadata;

  const SignatureElement({required this.type, required this.id, required this.value, required this.metadata});

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'id': id,
      'value': value,
      'metadata': metadata,
    };
  }

  factory SignatureElement.text({
    required String id,
    required String value,
    required Map<String, dynamic> metadata,
  }) {
    return SignatureElement(
      type: SigElementType.text,
      id: id,
      value: value,
      metadata:metadata,
    );
  }

  factory SignatureElement.gif({
    required String id,
    required String value,
    required Map<String, dynamic> metadata,
  }) {
    return SignatureElement(
      type: SigElementType.gif,
      id: id,
      value: value,
      metadata:metadata,
    );
  }
  factory SignatureElement.fromMap(Map<String, dynamic> map) {
    return SignatureElement(
      type: SigElementType.values.byName(map['type']),
      id: map['id'] as String,
      value: map['value'] as String,
      metadata: Map.from(map['metadata']),
    );
  }

  SignatureElement copyWith({
    SigElementType? type,
    String? id,
    String? value,
    Map<String, dynamic>? metadata,
  }) {
    return SignatureElement(
      type: type ?? this.type,
      id: id ?? this.id,
      value: value ?? this.value,
      metadata: metadata ?? this.metadata,
    );
  }
}
