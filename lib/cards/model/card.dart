import 'package:celebrated/cards/controller/card.themes.service.dart';
import 'package:celebrated/cards/model/card.sign.dart';
import 'package:celebrated/cards/model/card.theme.dart';
import 'package:celebrated/cards/model/send.method.dart';
import 'package:celebrated/domain/model/imodel.dart';
import 'package:celebrated/navigation/controller/route.names.dart';

class CelebrationCard extends IModel {
  final CardSendMethod method;
  final String to;
  final String from;
  final String title;
  final String toEmail;
  final String authorId;

  final String templateId;
  final Map<String, CardSign> signatures;
  final DateTime sendWhen;
  final bool cardSent;
  final String themeId;
  final bool sendManually;
  final int pages;

  CelebrationCard(
      {required this.method,
      required this.to,
      required this.toEmail,
      this.sendManually = false,
      required this.sendWhen,
      required this.pages,
      required this.from,
      required this.templateId,
      required this.title,
      required this.themeId,
      required final String id,
      required this.authorId,
      this.cardSent = false,
      required this.signatures})
      : super(id);

  bool get failedToSend =>
      cardSent == false &&
      sendWhen.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch &&
      signatures.isNotEmpty;

  bool get hasBackgroundImage => theme.cardFront.isNotEmpty;

  static CelebrationCard empty() {
    return CelebrationCard(
        method: CardSendMethod.email,
        sendWhen: DateTime.now(),
        cardSent: false,
        to: '',
        pages: 0,
        from: '',
        title: '',
        themeId: '',
        id: '',
        authorId: '',
        signatures: {},
        templateId: '',
        toEmail: '');
  }

  CelebrationCardTheme get theme {
    try {
      return cardThemesService.themes.firstWhere((element) => element.id == themeId);
    } catch (_) {
      return CelebrationCardThemesService.themesList.first;
    }
  }

  CelebrationCard copyWith({
    CardSendMethod? method,
    String? to,
    String? from,
    String? title,
    String? themeId,
    String? templateId,
    bool? sendManually,
    String? id,
    String? authorId,
    Map<String, CardSign>? signatures,
    DateTime? sendWhen,
    bool? cardSent,
    String? toEmail,
    int? pages,
  }) {
    return CelebrationCard(
      method: method ?? this.method,
      to: to ?? this.to,
      from: from ?? this.from,
      title: title ?? this.title,
      themeId: themeId ?? this.themeId,
      id: id ?? this.id,
      pages: pages ?? this.pages,
      toEmail: toEmail ?? this.toEmail,
      sendManually: sendManually ?? this.sendManually,
      cardSent: cardSent ?? this.cardSent,
      templateId: templateId ?? this.templateId,
      authorId: authorId ?? this.authorId,
      signatures: signatures ?? this.signatures,
      sendWhen: sendWhen ?? this.sendWhen,
    );
  }

  CelebrationCard withSignature(CardSign cardSign) {
    final newSigns = {...signatures, cardSign.id: cardSign};

    return copyWith(signatures: newSigns);
  }

  CelebrationCard withRemovedSignature(CardSign cardSign) {
    return copyWith(signatures: signatures..remove(cardSign.id));
  }

  String get shareUrl {
    return "${AppRoutes.domainUrlBase}${AppRoutes.cardPreview}?id=$id&page=0";
  }




}
