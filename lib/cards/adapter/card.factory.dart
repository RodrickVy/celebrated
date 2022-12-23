import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/cards/model/card.sign.dart';
import 'package:celebrated/cards/model/send.method.dart';
import 'package:celebrated/domain/model/imodel.factory.dart';

class CelebrationCardFactory extends IModelFactory<CelebrationCard> {
  @override
  CelebrationCard fromJson(Map<String, dynamic> json) {
    return CelebrationCard(
      method: CardSendMethod.values.byName(json['method'] ?? 'email'),
      to: json['to'],
      from: json['from'],
      title: json['title'],
      templateId: json['templateId'] ?? '',
      toEmail: json["toEmail"],
      themeId: json['themeId'] ?? '',
      id: json['id'],
      pages: json['pages'] ?? 0,
      sendManually: json["sendManually"] ?? false,
      authorId: json['authorId'],
      cardSent: json['cardSent'],
      signatures: Map.fromIterable(List.from(json['signatures'] ?? []).map((e) => CardSign.fromMap(e)),
          key: (e) => e.id, value: (e) => e),
      sendWhen: DateTime.fromMillisecondsSinceEpoch(json["sendWhen"]),
    );
  }

  @override
  Map<String, dynamic> toJson(CelebrationCard model) {
    return {
      'method': model.method.name,
      'to': model.to,
      'from': model.from,
      'title': model.title,
      'toEmail': model.toEmail,
      'authorId': model.authorId,
      'templateId': model.templateId,
      'signatures': model.signatures.values.map((e) => e.toMap()).toList(),
      'sendWhen': model.sendWhen.millisecondsSinceEpoch,
      'cardSent': model.cardSent,
      'themeId': model.themeId,
      'sendManually': model.sendManually,
      'pages': model.pages,
    };
  }
}
