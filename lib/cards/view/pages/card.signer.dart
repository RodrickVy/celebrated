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
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/id.generator.dart';
import 'package:celebrated/util/list.extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardSigner extends AdaptiveUI {
   CardSigner({super.key});



  static int get currentPage => int.parse(Get.parameters['page']??'0');

  final PageController _cardSignerController = PageController(
    initialPage: int.parse(Get.parameters['page']??'0'),
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

              return SizedBox(
                width: adapter.width,
                height: adapter.height,
                child: Stack(
                  children: [
                    SizedBox(
                      width: adapter.width,
                      height: adapter.height - 40,
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _cardSignerController,
                        scrollDirection: Axis.vertical,
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
                    Positioned.fill(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: currentPage <= 0 ? Colors.grey :AppSwatch.primary ,
                              child: AppIconButton(
                                  icon: const Icon(
                                    Icons.arrow_upward,
                                    color: Colors.black,
                                  ),
                                  noBg: currentPage <= 0 ,
                                  onPressed: () {
                                  //  _cardSignerController.animateTo(_cardSignerController.offset - adapter.height,duration: const Duration(milliseconds:500),curve: Curves.easeInCubic);
                                    if(currentPage >= 1){
                                      navService.routeToParameter('page', (currentPage-1).toString());

                                    }

                                  }),
                            ),
                            Container(
                              decoration: AppTheme.boxDecoration.copyWith(
                                color: Colors.white
                              ),
                              margin: EdgeInsets.all(4),
                              padding: const EdgeInsets.all(20),
                              child: Text(" $currentPage / ${card.signatures.length+1}"),
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: currentPage >= card.signatures.length+1 ? Colors.grey :AppSwatch.primary ,
                              child: AppIconButton(
                                  icon: const Icon(
                                    Icons.arrow_downward,
                                    color: Colors.black,
                                  ),
                                  noBg: currentPage >= card.signatures.length+1,
                                  onPressed: () {
                                   // _cardSignerController.animateTo(_cardSignerController.offset + adapter.height,duration: const Duration(milliseconds:500),curve: Curves.easeInCubic);
                                    if(currentPage <= card.signatures.length){
                                      navService.routeToParameter('page', (currentPage+1).toString());

                                    }

                                  }),
                            ),
                            const SizedBox(width: 30,),
                            AppButtonIcon(icon: const Icon(Icons.add) , onPressed: (){
                              addNewSignature(card);
                            },label: "sign",)
                          ],
                        ),
                      ),
                    )
                  ],
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
          .withSignature(CardSign(id: IDGenerator.generateId(10,card.id), elements: []))
          .signatures
          .values
          .map((e) => e.toMap())
          .toList(),
    });
    navService.routeToParameter('page', (card.signatures.length+1).toString());
  }
}
