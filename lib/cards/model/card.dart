import 'package:celebrated/domain/model/imodel.dart';

enum CardSendMethod { email, sms }

class BirthdayCard extends IModel {
  final CardSendMethod method;
  final String to;
  final String from;
  final String title;
  final String image;
  @override
  final String id;
  final String authorId;
  final String template;
  final List<CardSigner> signers;
  final DateTime sendWhen;

  BirthdayCard(
      {required this.method,
      required this.to,
      required this.sendWhen,
      required this.from,required this.template,
        required this.title,
      required this.image,
      required this.id,
      required this.authorId,
      required this.signers})
      : super(id);

  Map<String, dynamic> toMap() {
    return {
      'method': method,
      'to': to,
      'from': from,
      'title': title,
      'image': image,
      'id': id,
      'template':template,
      'authorId': authorId,
      'signer': signers,
    };
  }



  static BirthdayCard empty() {
    return BirthdayCard(
        method: CardSendMethod.email,sendWhen: DateTime.now(), to: '', from: '', title: '', image: '', id: '', authorId: '', signers: [], template: '');
  }

  BirthdayCard copyWith({
    CardSendMethod? method,
    String? to,
    String? from,
    String? title,
    String? image,
    String? template,
    String? id,
    String? authorId,
    List<CardSigner>? signers,
    DateTime? sendWhen,
  }) {
    return BirthdayCard(
      method: method ?? this.method,
      to: to ?? this.to,
      from: from ?? this.from,
      title: title ?? this.title,
      image: image ?? this.image,
      id: id ?? this.id,
      template: template ?? this.template,
      authorId: authorId ?? this.authorId,
      signers: signers ?? this.signers,
      sendWhen: sendWhen ?? this.sendWhen,
    );
  }
}

class CardSigner {
  final String name;
  final String message;
  final int pageNumber;
  final double left;
  final double top;

  CardSigner(
      {required this.pageNumber, required this.left, required this.top, required this.name, required this.message});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'message': message,
      'pageNumber': pageNumber,
      'left': left,
      'top': top,
    };
  }

  factory CardSigner.fromMap(Map<String, dynamic> map) {
    return CardSigner(
      name: map['name'] as String,
      message: map['message'] as String,
      pageNumber: map['pageNumber'] as int,
      left: map['left'] as double,
      top: map['top'] as double,
    );
  }

  CardSigner copyWith({
    String? name,
    String? message,
    int? pageNumber,
    double? left,
    double? top,
  }) {
    return CardSigner(
      name: name ?? this.name,
      message: message ?? this.message,
      pageNumber: pageNumber ?? this.pageNumber,
      left: left ?? this.left,
      top: top ?? this.top,
    );
  }
}
