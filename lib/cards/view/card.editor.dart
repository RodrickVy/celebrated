import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/cards/controller/cards.controller.dart';
import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/cards/view/card.thumb.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/text.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/domain/view/pages/task.stage.pages.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';


class CardEditor extends AdaptiveUI {
  const CardEditor({super.key});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    if(cardsController.currentCard == null){
      return const TaskFailed(title: "Sorry this card is not found",image: 'assets/intro/data_not_found.png',);
    }
    return ListView(
      children: [
        const Heading("Lets get you started "),
        UIFormState.nameField.copyWith(
          label: "Who is the card from?",
          controller: TextEditingController(text: authService.user.name)
        ),
        UIFormState.sendToRecipientField.copyWith(
            label: "Who is the card too?",
        ),

        UIFormState.emailField.copyWith(
          label: "Whats their email?",
          hint: "email"
        ),


        Wrap(
          children: [
            ...cardsController.birthdayCards.values.map((BirthdayCard value) {
              return CardPreview(card: value);
            }).toList(),
          ],
        ),
        if (cardsController.birthdayCards.isEmpty)
          Image.asset(
            "assets/intro/card.png",
            width: adapter.adapt(phone: 100, tablet: 150, desktop: 200),
          ),
        if (cardsController.birthdayCards.isEmpty) const BodyText("You have no cards yet"),
        AppButtonIcon(
          onPressed: () async {
            cardsController.createNewCard();
          },
          isTextButton: true,
          icon: const Icon(Icons.add),
          label: "Next",
        ),
      ],
    );
  }
}
