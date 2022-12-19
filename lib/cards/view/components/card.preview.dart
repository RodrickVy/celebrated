import 'package:celebrated/app.theme.dart';
import 'package:celebrated/cards/controller/cards.service.dart';
import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/cards/view/components/card.back.page.dart';
import 'package:celebrated/cards/view/components/card.front.page.dart';
import 'package:celebrated/domain/model/drop.down.action.dart';
import 'package:celebrated/domain/view/components/text.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/models/app.error.code.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:celebrated/support/view/components/prompt.snack.actions.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/date.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CardPreview extends AdaptiveUI {
  final CelebrationCard card;
  final bool withEditActions;

  const CardPreview({
    Key? key,
    required this.card,
    this.withEditActions = false,
  }) : super(key: key);
  List<OptionAction> get actions => [
    OptionAction("Delete", Icons.delete, () async {
      FeedbackService.announce(
        ///todo change Error Codes to notification codes
        notification: AppNotification(
            message: '',
            appWide: true,
            canDismiss: false,
            type: NotificationType.warning,
            title: "Are you sure you want to this birthday card delete?",
            code: ResponseCode.unknown,
            child: PromptSnackActions(
              onCancel: () {},
              actionLabel: "Delete",
              cancelLabel: "Cancel",
              onAction: () async {
                await cardsController.deleteContent(card.id);
              },
            )),
      );
    }),
    OptionAction("Edit", Icons.edit, () async {
      navService.to("${AppRoutes.cardEditor}?id=${card.id}");
    }),
    OptionAction("Preview", Icons.remove_red_eye_sharp, () {})
  ];
  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Stack(
      children: [
        FlipCard(
          fill: Fill.fillBack, // Fill the back side of the card to make in the same size as the front.
          direction: FlipDirection.HORIZONTAL, // default
          front: CardFrontPage(
            card: card,
            width: 320,
            height: 600,
          ),
          back: CardBackPage(
            card: card,
            width: 320,
            height: 600,
          ),
        ),
        if(withEditActions)
        Positioned.fill(
          bottom: 0,
          left: 0,
          child: Container(
            alignment: Alignment.bottomLeft,
            height: 260,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: adapter.width,
                  height: 60,color: Colors.white,
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    children: [
                      ...actions.map((e) => IconButton(
                        onPressed: e.action,
                        icon: Icon(e.icon),
                      ))
                    ],
                  ),
                ),
                if (card.failedToSend)
                  Container(
                    width: adapter.width,
                    color: Colors.red,
                    child: const BodyText(
                        "There was a problem sending this card, at the scheduled time, please reschedule the sending. "),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// use of routes, we are using routes for two things , one is to store the current list and now its to get the current birthday in edit mode.
}


