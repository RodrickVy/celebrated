import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/cards/controller/cards.service.dart';
import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/cards/model/card.sign.dart';
import 'package:celebrated/cards/model/card.theme.dart';
import 'package:celebrated/cards/model/text.style.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/editable.text.field.dart';
import 'package:celebrated/domain/view/components/text.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/main.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/id.generator.dart';
import 'package:celebrated/util/list.extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_editor/text_editor.dart';
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

class CardViewer extends AdaptiveUI {
  CardViewer({super.key});



  static int get currentPage => int.parse(Get.parameters['page']??'0');

  final PageController _cardSignerController = PageController(
    initialPage: int.parse(Get.parameters['page']??'0'),
  );
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
          Size cardSize = card.theme.computeSizeFromRatio(const Size(400,500));

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
                            width: cardSize.width,
                            height:  cardSize.height,
                          )),
                      if (signatures.isEmpty)
                        TaskFailed(
                          title: "This card is empty",
                          image: "assets/intro/notification.png",
                          buttonLabel: "Go back",
                        ),
                      ...signatures.map2((signature, index) {
                        return _CardPreviewPage(
                          card: card,
                          signature: signature,
                        );
                      }),
                      Container(
                          alignment: Alignment.center,
                          child: CardBackPage(
                            card: card,
                            width: cardSize.width,
                            height:  cardSize.height,
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
  }


}


String giffyAPIKey = "rcFrjQfPwLydblY9vsX6VuM6neiDLGRy";
GiphyGif? giffy;

class _CardPreviewPage extends AdaptiveUI {
  final CelebrationCard card;
  final CardSign signature;

  const _CardPreviewPage({required this.signature, super.key, required this.card});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        height: adapter.height,
        child: Center(
          child: SizedBox(
            width: 400,
            child: Card(
              shape: AppTheme.shape,
              child: ListView(
                padding: const EdgeInsets.all(30),
                children: [

                  ...signature.elements.values.map((SignatureElement element) {
                    switch (element.type) {
                      case SigElementType.text:
                        return SignTextPreviewElement(

                          element: element,

                        );
                      case SigElementType.gif:
                        return GifSignPreviewElement(
                          element: element,
                        );
                    }
                  }),
                  SizedBox(height: 260,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}

class SignTextPreviewElement extends AdaptiveUI {
  final SignatureElement element;


  const SignTextPreviewElement({required this.element, super.key});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        element.value,
        style: element.metadata.asTextStyle,
        textAlign: element.metadata.asAlignment,
      ),
    );
  }
}

class GifSignPreviewElement extends AdaptiveUI {
  final SignatureElement element;


  const GifSignPreviewElement({required this.element});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return GiphyGetWrapper(
        giphy_api_key: giffyAPIKey,
        builder: (stream, giphyGetWrapper) => StreamBuilder<GiphyGif>(
            stream: stream,
            initialData: element.metadata.toGif,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ?  GiphyGifWidget(
                imageAlignment: Alignment.center,
                gif: element.metadata.toGif,
                giphyGetWrapper: giphyGetWrapper,
                borderRadius: BorderRadius.circular(30),
                showGiphyLabel: true,
              )
                  : Text("No GIF");
            }));
  }
}



