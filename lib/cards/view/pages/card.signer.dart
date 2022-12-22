import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/cards/controller/cards.service.dart';
import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/cards/model/card.sign.dart';
import 'package:celebrated/cards/view/components/card.back.page.dart';
import 'package:celebrated/cards/view/components/card.front.page.dart';
import 'package:celebrated/cards/view/components/card.sign.page.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/domain/view/pages/loading.dart';
import 'package:celebrated/domain/view/pages/task.stage.pages.dart';
import 'package:celebrated/main.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/id.generator.dart';
import 'package:celebrated/util/list.extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardSigner extends AdaptiveUI {
  CardSigner({super.key});

  final PageController _cardSignerController = PageController(
    initialPage: cardsController.currentSignIndex.value,
  );

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
      () {
        cardsController.birthdayCards.value;

        return FutureBuilder(
          future: cardsController.cardFromUrlParam,
          builder: (BuildContext context, AsyncSnapshot<CelebrationCard?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingSpinner(
                message: "Loading your card...",
              );
            } else if (snapshot.hasData && snapshot.data == null) {
              return const TaskFailed(
                title: "Sorry this card is not found",
                image: 'assets/intro/data_not_found.png',
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              final CelebrationCard card = snapshot.data!;

              final List<CardSign> signatures = card.signatures.values.toList();

              return Scaffold(
                appBar: AppBar(
                  actions: [
                    AppIconButton(
                        icon: const Icon(
                          Icons.arrow_upward,
                          color: Colors.black,
                        ),
                        noBg: true,
                        onPressed: () {
                          _cardSignerController.animateTo(_cardSignerController.offset - adapter.height,
                              duration: const Duration(milliseconds: 500), curve: Curves.easeInCubic);
                          //   if( cardsController.currentSignIndex.value >= 1){
                          //     navService.routeToParameter('page', ( cardsController.currentSignIndex.value-1).toString());
                          //
                          //   }
                        }),
                    // Container(
                    //   decoration: AppTheme.boxDecoration.copyWith(
                    //     color: Colors.white
                    //   ),
                    //   margin: EdgeInsets.all(4),
                    //   padding: const EdgeInsets.all(20),
                    //   child: Text(" ${ cardsController.currentSignIndex.value} / ${card.signatures.length+1}"),
                    // ),
                    AppIconButton(
                        icon: const Icon(
                          Icons.arrow_downward,
                          color: Colors.black,
                        ),
                        noBg: true,
                        onPressed: () {
                          _cardSignerController.animateTo(_cardSignerController.offset + adapter.height,
                              duration: const Duration(milliseconds: 500), curve: Curves.easeInCubic);
                          //  if( cardsController.currentSignIndex.value <= card.signatures.length){
                          //    navService.routeToParameter('page', ( cardsController.currentSignIndex.value+1).toString());
                          //
                          //  }
                        }),
                    Obx(() {
                      if (authService.userLive.value.uid == card.authorId &&
                          cardsController.currentSignIndex.value > 0 &&
                          cardsController.currentSignIndex.value <= card.signatures.length) {
                        return AppIconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await deleteSign(card, signatures[cardsController.currentSignIndex.value-1]);
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    AppIconButton(
                        icon: Icon(Icons.draw),
                        onPressed: () {
                          addNewSignature(card);
                        }),
                  ],
                ),
                body: SizedBox(
                  width: adapter.width,
                  height: adapter.height,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: adapter.width,
                        height: adapter.height - 40,
                        child: PageView(
                          // physics: NeverScrollableScrollPhysics(),
                          controller: _cardSignerController,
                          scrollDirection: Axis.vertical,
                          restorationId: "cards_sign_page",
                          onPageChanged: (int index) {
                            cardsController.currentSignIndex(index);
                          },
                          children: [
                            Container(
                                alignment: Alignment.center,
                                child: CardFrontPage(
                                  card: card,
                                  width: adapter.adapt(phone: 300, tablet: 500, desktop: 600),
                                  height: adapter.adapt(phone: 600, tablet: 1000, desktop: 1200),
                                )),
                            if (signatures.isEmpty)
                              TaskFailed(
                                title: "Be the first to sign!",
                                image: "assets/intro/notification.png",
                                buttonLabel: "Sign",
                                buttonAction: () async {
                                  await addNewSignature(card);
                                },
                              ),
                            ...signatures.map2((signature, index) {
                              return CardSignPage(
                                card: card,
                                signature: signature,
                              );
                            }),
                            Container(
                                alignment: Alignment.center,
                                child: CardBackPage(
                                  card: card,
                                  width: adapter.adapt(phone: 300, tablet: 500, desktop: 600),
                                  height: adapter.adapt(phone: 600, tablet: 1000, desktop: 1200),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return TaskFailed(
                title: "Sorry this card is not found",
                image: 'assets/intro/data_not_found.png',
                buttonAction: () {
                  if (authService.userLive.value.isAuthenticated) {
                    navService.to(AppRoutes.cards);
                  } else {
                    navService.back();
                  }
                },
                buttonLabel: authService.userLive.value.isAuthenticated ? "Back to cards" : "Back",
              );
            }
          },
        );
      },
    );
  }

  Future<void> addNewSignature(CelebrationCard card) async {
    await cardsController.updateContent(card.id, {
      "signatures": card
          .withSignature(CardSign(id: IDGenerator.generateId(10, card.id), elements: []))
          .signatures
          .values
          .map((e) => e.toMap())
          .toList(),
    });
    navService.routeToParameter('page', (card.signatures.length + 1).toString());
  }

  Future<void> deleteSign(CelebrationCard card, CardSign signature) async {
    await cardsController.updateContent(card.id,
        {'signatures': card.withRemovedSignature(signature).signatures.values.map((value) => value.toMap()).toList()});
  }
}
