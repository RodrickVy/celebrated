import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/cards/controller/card.editor.dart';
import 'package:celebrated/cards/controller/cards.service.dart';
import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/cards/model/card.sign.dart';
import 'package:celebrated/cards/model/card.theme.dart';
import 'package:celebrated/cards/view/components/card.back.page.dart';
import 'package:celebrated/cards/view/components/card.front.page.dart';
import 'package:celebrated/cards/view/components/card.sign.page.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/text.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/domain/view/pages/coming.soon.view.dart';
import 'package:celebrated/domain/view/pages/loading.dart';
import 'package:celebrated/domain/view/pages/task.stage.pages.dart';
import 'package:celebrated/live.editor/model/live.canvas.dart';
import 'package:celebrated/live.editor/views/live.canvas.edit.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/id.generator.dart';
import 'package:celebrated/util/list.extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final RxInt currentSignIndex = 0.obs;

final List<String> cardfeatures = [
  "add text and style it your way",
  "use giffy gifs",
  "over 1000+ stickers",
  "add imoji",
  "drag and resize however you want!"
];

class CardSigner extends AdaptiveUI {
  CardSigner({super.key}) {
    _cardSignerController = PageController(
      initialPage: currentSignIndex.value,
    );
  }

  late PageController _cardSignerController;

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
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
          final Size cardSize = getMaxFitSize(Size(adapter.height, adapter.width), card.theme.cardRatio);
          final CelebrationCardsEditor editor = CelebrationCardsEditor(
            initialCanvases: card.signatures.values.map((e) => e.toCanvas(cardSize)).toList(),
            card: card,
          );
          return Obx(
            () {
              editor.controllers.value;
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
                          previousPage(adapter);
                        }),
                    AppIconButton(
                        icon: const Icon(
                          Icons.arrow_downward,
                          color: Colors.black,
                        ),
                        noBg: true,
                        onPressed: () {
                          nextPage(adapter);
                        }),
                    Obx(() {
                      if (authService.userLive.value.uid == card.authorId &&
                          currentSignIndex.value > 1 && editor.controllers.isNotEmpty &&
                          currentSignIndex.value <= card.signatures.length+1) {
                        return AppIconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            editor.removeCanvas(editor.canvases[currentSignIndex.value - 2]);
                            previousPage(adapter);
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    AppIconButton(
                        icon: const Icon(Icons.draw),
                        onPressed: () {
                          editor.addCanvas(
                              LiveEditorCanvas.generateNew.copyWith(width: cardSize.width, height: cardSize.height));
                          nextPage(adapter);
                        }),
                  ],
                ),
                body: SizedBox(
                  width: adapter.width,
                  height: adapter.height - 40,
                  child: PageView(
                    // physics: NeverScrollableScrollPhysics(),
                    controller: _cardSignerController,
                    scrollDirection: Axis.vertical,
                    restorationId: "cards_sign_page",
                    onPageChanged: (int index) {
                      currentSignIndex.value = index;
                    },
                    children: [
                      Container(
                          alignment: Alignment.center,
                          child: CardFrontPage(
                            card: card,
                          )),
                      if (editor.controllers.isEmpty)
                        TaskFailed(
                          title: "Be the first to sign!",
                          image: "assets/intro/notification.png",
                          buttonLabel: "Sign",
                          buttonAction: () async {
                            editor.addCanvas(
                                LiveEditorCanvas.generateNew.copyWith(width: cardSize.width, height: cardSize.height));
                            nextPage(adapter);
                          },
                        ),
                      if (editor.controllers.isNotEmpty)
                        Container(
                          height: adapter.height,
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.zero,
                          width: adapter.width,
                          color: Colors.white,
                          child: Center(
                            child: SizedBox(
                              width: adapter.adapt(phone: adapter.width, tablet: 600, desktop: 600),
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/intro/card.png',
                                    width: 150,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Sign It Your Way",
                                    style: adapter.textTheme.headline5,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ChoiceChip(
                                    elevation: 0,
                                    label: const Text("over 5 different ways to do it!"),
                                    onSelected: (bool value) {
                                      navService.to(AppRoutes.support);
                                    },
                                    shape: AppTheme.shape,
                                    backgroundColor: Colors.white,
                                    selected: false,
                                  ),
                                ),
                                ...cardfeatures.map((e) {
                                  return Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(e),
                                        const Divider(color: Colors.black26,thickness: 0.6,indent: 100,endIndent: 100,)
                                      ],
                                    ),
                                  );
                                }),

                                AppButtonIcon(
                                  label:'Lets sign!' ,
                                    icon: Icon(Icons.draw),
                                    onPressed: () {
                                      editor.addCanvas(LiveEditorCanvas.generateNew
                                          .copyWith(width: cardSize.width, height: cardSize.height));
                                      nextPage(adapter);
                                    })
                              ]),
                            ),
                          ),
                        ),
                      ...editor.controllers.values.map((controller) {
                        return LiveCanvas(
                          controller: controller,
                        );
                      }),
                      Container(
                          alignment: Alignment.center,
                          child: CardBackPage(
                            card: card,
                          )),
                    ],
                  ),
                ),
              );
            },
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
  }

  nextPage(Adaptive adapter) {
    _cardSignerController.animateTo(_cardSignerController.offset + adapter.height,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInCubic);
  }

  previousPage(Adaptive adapter) {
    _cardSignerController.animateTo(_cardSignerController.offset - adapter.height,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInCubic);
  }

// Future<void> addNewSignature(CelebrationCard card) async {
//   await cardsController.updateContent(card.id, {
//     "signatures": card
//         .withSignature(CardSign(id: IDGenerator.generateId(10, card.id), elements: []))
//         .signatures
//         .values
//         .map((e) => e.toMap())
//         .toList(),
//   });
//   _cardSignerController.animateTo(_cardSignerController.offset + adapter.height,
//       duration: const Duration(milliseconds: 500), curve: Curves.easeInCubic);
//
// }
//
// Future<void> deleteSign(CelebrationCard card, CardSign signature) async {
//   await cardsController.updateContent(card.id,
//       {'signatures': card
//           .withRemovedSignature(signature)
//           .signatures
//           .values
//           .map((value) => value.toMap())
//           .toList()});
// }
}
