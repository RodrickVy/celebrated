import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/cards/controller/cards.service.dart';
import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/cards/view/components/card.preview.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/text.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class CardsListPage extends AdaptiveUI {
  const CardsListPage({super.key});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
      () {
        cardsController.birthdayCards.value;
        return Center(
        child: SizedBox(
          width: 350,
          child: ListView(
            children: [
              SizedBox(height:20),
              const Heading("Your Birthday Cards"),
              Wrap(
               direction: Axis.horizontal,
                children: [
                  ...cardsController.birthdayCards.values.map((CelebrationCard value) {
                    return GestureDetector(onTap: () {
                      navService.to("${AppRoutes.cardEditor}?id=${value.id}");
                    }, child: CardPreview(card: value,withEditActions: true,));
                  }).toList(),
                ],
              ),


              if (cardsController.birthdayCards.isEmpty || authService.user.isUnauthenticated) ...[
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/intro/card.png",
                    width: adapter.adapt(phone: 100, tablet: 150, desktop: 200),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Create birthday cards",
                    style: adapter.textTheme.headline5,
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    "Create unique birthday cards that you can invite others to sign.  Ad image/video etc on card and easily share via link.",
                    // style: adapter.textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                ),
                if (cardsController.birthdayCards.isEmpty) const BodyText("You have no cards yet"),
              ],
              if (authService.user.isUnauthenticated)
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: AppButton(
                      onPressed: () async {
                        navService.routeKeepNext(AppRoutes.authSignIn,AppRoutes.cards);
                      },
                      isTextButton: true,
                      child: const Text(
                        "SignIn",
                      )),
                ),
              if (authService.user.isUnauthenticated)
                const Padding(
                  padding: EdgeInsets.only(left: 4.0, right: 4),
                  child: Text(
                    "or",
                    textAlign: TextAlign.center,
                  ),
                ),
              if (authService.user.isUnauthenticated)
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: AppButton(
                      onPressed: () async {
                        navService.routeKeepNext(AppRoutes.authSignUp,AppRoutes.cards);
                      },
                      isTextButton: true,
                      child: const Text(
                        "create account",
                      )),
                ),
              if(authService.userLive.value.isAuthenticated)
               AppButtonIcon(
                onPressed: () async {
                  cardsController.createNewCard();
                },
                isTextButton: true,
                icon: const Icon(Icons.add),
                label: "Create New Card",
              ),
            ],
          ),
        ),
      );
      },
    );
  }
}
