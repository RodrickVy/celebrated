import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/cards/controller/card.themes.service.dart';
import 'package:celebrated/cards/controller/cards.service.dart';
import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/cards/view/components/card.preview.dart';
import 'package:celebrated/domain/model/toggle.option.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/copy.text.dart';
import 'package:celebrated/domain/view/components/text.dart';
import 'package:celebrated/domain/view/components/toogle.button.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/domain/view/pages/loading.dart';
import 'package:celebrated/domain/view/pages/task.stage.pages.dart';
import 'package:celebrated/lists/controller/birthdays.controller.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';

import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:search_choices/search_choices.dart';

class CardEditor extends AdaptiveUI {
  const CardEditor({super.key});

  static RxBool changesMade = RxBool(false);

  String?  initialLinkedBirthday(card) {
    try {
      return birthdaysController.getAllBirthdays.firstWhere((element) {
        return element.name == card.from &&
            element.dateWithThisYear.year == card.sendWhen.year &&
            element.dateWithThisYear.month == card.sendWhen.month &&
            element.dateWithThisYear.day == card.sendWhen.day;
      }).name;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
          () {

        cardsController.birthdayCards.value;

        return FutureBuilder(future:cardsController.cardFromUrlParam,builder: (BuildContext context, AsyncSnapshot<CelebrationCard?> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const LoadingSpinner(message: "Loading your card...",);
          } else if(snapshot.hasData && snapshot.data == null){
            return const TaskFailed(
              title: "Sorry this card is not found",
              image: 'assets/intro/data_not_found.png',
            );
          }else if(snapshot.hasData && snapshot.data != null){
            final CelebrationCard card = snapshot.data!;
            UIFormState.cardSenderName = card.from.isNotEmpty ? card.from : authService.user.name;
            UIFormState.cardRecipientName = card.to.isNotEmpty ? card.to : '';
            UIFormState.cardRecipientEmail = card.toEmail;
            UIFormState.cardSendDate = card.sendWhen.toIso8601String();
            return Center(
              child: SizedBox(
                width: 350,
                child: ListView(
                  children: [
                    const Heading("Lets get you started "),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SearchChoices.single(
                          hint: "Link card with birthday",
                          style: adapter.textTheme.subtitle2,
                          emptyListWidget: const SizedBox(),
                          dialogBox: true,
                          value: initialLinkedBirthday(card),
                          onTap: () {},

                          onChanged: () {},
                          // showDialogFn: ,
                          items: birthdaysController.getAllBirthdays.map((e) {
                            return DropdownMenuItem(
                              child: Text(e.name),
                              onTap: () async {
                                await cardsController.updateContent(card.id, {
                                  'to': e.name,
                                  'sendWhen': e.dateWithThisYear.millisecondsSinceEpoch,
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    UIFormState.nameField.copyWith(
                        label: "Sender name",
                        controller: TextEditingController(text: UIFormState.cardSenderName),
                        onChanged: (c) {
                          FeedbackService.clearErrorNotification();
                          if (c != UIFormState.cardSenderName) {
                            changesMade(true);
                          }

                          UIFormState.cardSenderName = c;
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    UIFormState.nameField.copyWith(
                        label: "Recipient Name",
                        controller: TextEditingController(text: UIFormState.cardRecipientName),
                        onChanged: (c) {
                          FeedbackService.clearErrorNotification();
                          if (c != UIFormState.cardRecipientName) {
                            changesMade(true);
                          }
                          UIFormState.cardRecipientName = c;

                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    UIFormState.emailField.copyWith(
                        label: "Recipient email",
                        hint: "email",
                        controller: TextEditingController(text: UIFormState.cardRecipientEmail),
                        onChanged: (c) {
                          FeedbackService.clearErrorNotification();
                          if (c != UIFormState.cardRecipientEmail) {
                            changesMade(true);
                          }
                          UIFormState.cardRecipientEmail = c;

                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    Obx(
                          () {
                            changesMade.value;
                            return AppButton(
                        isTextButton: changesMade.value == false,
                        onPressed: () async {
                          changesMade(false);
                          await cardsController.updateContent(card.id, {
                            'to': UIFormState.cardRecipientName,
                            'from': UIFormState.cardSenderName,
                            'toEmail': UIFormState.cardRecipientEmail,
                          });
                        },
                        label: "Save",
                      );
                          },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CardPreview(
                      card: card,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...cardThemesService.themes.map((e) {
                            Size cardSize = card.theme.computeSizeFromRatio(const Size(100,100));
                            return GestureDetector(
                              onTap: () async {
                                await cardsController.updateContent(card.id, {
                                  'themeId': e.id,
                                });
                              },
                              child: Container(
                                width: cardSize.width,
                                height: cardSize.height,
                                margin: const EdgeInsets.all(5),
                                padding: EdgeInsets.zero,
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  shape: AppTheme.shape.copyWith(
                                  side: card.themeId == e.id ? const BorderSide(color: Colors.lightGreen, width: 2) : null),
                                  elevation: 0,
                                  child:Stack(
                                    children: [
                                      Container(
                                        width: cardSize.width,
                                        height: cardSize.height,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          e.cardFront,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            radius: 10,
                                            backgroundColor: e.foregroundColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ) ,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Heading(
                            "How should we send this card",
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: AppToggleButton(
                              onInteraction: () {},
                              multiselect: false,
                              options: [
                                ToggleOption(
                                    view: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Row(
                                        children: const [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(" I will share it myself "),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                    state: card.sendManually == true,
                                    onSelected: () {
                                      cardsController.updateContent(card.id, {'sendManually': true});
                                    }),
                                ToggleOption(
                                    view: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Row(
                                        children: const [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(Icons.auto_mode),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(" Auto Send"),
                                          SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                    state: card.sendManually == false,
                                    onSelected: () {
                                      cardsController.updateContent(card.id, {'sendManually': false});
                                    }),
                              ],
                            ),
                          ),
                          if (card.sendManually == false)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DateTimePicker(
                                  firstDate: DateTime.tryParse('1997-05-03'),
                                  controller: TextEditingController(text: UIFormState.cardSendDate),
                                  initialDate: card.sendWhen,
                                  enabled: card.sendManually,
                                  decoration: InputDecoration(
                                      labelText: "When would you like us to email the card to the Recipient?",
                                      hintText: UIFormState.cardSendDate),
                                  onSaved: (data) {
                                    cardsController.updateContent(card.id, {'sendWhen': UIFormState.cardSendDate});
                                  },
                                  onChanged: (d) {},
                                  type: DateTimePickerType.dateTime,
                                  lastDate: DateTime.fromMillisecondsSinceEpoch(
                                      DateTime.now().millisecondsSinceEpoch + DateTime.now().millisecondsSinceEpoch)),
                            ),
                          // if (card.sendManually == false)
                          //   ...CardSendMethod.values.map((e) {
                          //     return ListTile(
                          //       leading: Icon(cardsController.currentCard!.method == e
                          //           ? Icons.check_box
                          //           : Icons.check_box_outline_blank),
                          //       title: Text(e.name),
                          //       enabled: !cardsController.currentCard!.sendManually,
                          //       selected: cardsController.currentCard!.method == e,
                          //       onTap: () {
                          //         cardsController.updateContent(cardsController.currentCard!.id, {"method": e.name});
                          //       },
                          //     );
                          //   }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AppButtonIcon(
                        onPressed: () {
                          navService.to('${AppRoutes.signCard}?id=${card.id}');
                        },
                        icon: const Icon(Icons.share),
                        label: "Share for signing",
                      ),
                    ),
                    CopyText(textValue: card.shareUrl,),

                  ],
                ),
              ),
            );
          }else{
            return  TaskFailed(
              title: "Sorry this card is not found",
              image: 'assets/intro/data_not_found.png',
              buttonAction: (){
                if(authService.userLive.value.isAuthenticated){
                  navService.to(AppRoutes.cards);
                }else{
                  navService.back();
                }
              },
              buttonLabel: authService.userLive.value.isAuthenticated ? "Back to cards" : "Back",
            );
          }

        },);
      },
    );
  }
}


