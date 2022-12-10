import 'package:celebrated/cards/controller/cards.controller.dart';
import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/cards/view/card.thumb.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/text.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class CardsListPage extends AdaptiveUI {
  const CardsListPage({super.key});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Center(
      child: SizedBox(
        width: 350,
        child: ListView(
          children: [
            const Heading("Your Birthday Cards"),
            Wrap(
              children: [
                ...cardsController.birthdayCards.values.map((BirthdayCard value) {
                  return CardPreview(card: value);
                }).toList(),
              ],
            ),
            if (cardsController.birthdayCards.isEmpty)
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/intro/card.png",
                  width: adapter.adapt(phone: 100, tablet: 150, desktop: 200),
                ),
              ),
            if (cardsController.birthdayCards.isEmpty) const BodyText("You have no cards yet"),
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
  }
}
