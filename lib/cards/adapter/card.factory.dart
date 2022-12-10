// ignore_for_file: prefer_for_elements_to_map_from iterable

import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/domain/model/imodel.factory.dart';

class BirthdayCardFactory extends IModelFactory<BirthdayCard> {


  @override
  BirthdayCard fromJson(Map<String, dynamic> json) {
    return BirthdayCard(
      method: CardSendMethod.values.byName(json['method']??'email'),
      to: json['to'],
      from: json['from'],
      title: json['title'],
      template: json['template'],
      image: json['image'] ,
      id: json['id'],
      authorId: json['authorId'],
      signers: List.from(json['signer']??[]).map((e) => CardSigner.fromMap(e)).toList(),
      sendWhen: DateTime.fromMillisecondsSinceEpoch(json["sendWhen"]),
    );
  }

  @override
  Map<String, dynamic> toJson(BirthdayCard model) {
    return {
      'method': model.method.name,
      'to':  model.to,
      'from':  model.from,
      'title':  model.title,
      'template': model.template,
      'image':  model.image,
      'id':  model.id,
      'authorId':  model.authorId,
      'signers':  model.signers.map((e) => e.toMap()).toList(),
      "sendWhen":model.sendWhen.millisecondsSinceEpoch
    };
  }
}
