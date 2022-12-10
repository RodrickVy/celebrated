// import 'package:celebrated/app.theme.dart';
// import 'package:celebrated/cards/controller/cards.controller.dart';
// import 'package:celebrated/cards/model/card.dart';
// import 'package:celebrated/cards/view/card.thumb.dart';
// import 'package:celebrated/domain/view/components/app.button.dart';
// import 'package:celebrated/domain/view/components/text.dart';
// import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
// import 'package:celebrated/util/adaptive.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
//
//
// class CardCreator extends AdaptiveUI {
//   const CardCreator({super.key});
//
//   @override
//   Widget view({required BuildContext ctx, required Adaptive adapter}) {
//     return ListView(
//       children: [
//         const Heading("Select A Template"),
//         TemplateSelector(),
//
//         Wrap(
//           children: [
//             ...cardsController.birthdayCards.values.map((BirthdayCard value) {
//               return CardPreview(card: value);
//             }).toList(),
//           ],
//         ),
//         if (cardsController.birthdayCards.isEmpty)
//           Image.asset(
//             "assets/intro/card.png",
//             width: adapter.adapt(phone: 100, tablet: 150, desktop: 200),
//           ),
//         if (cardsController.birthdayCards.isEmpty) const BodyText("You have no cards yet"),
//         AppButtonIcon(
//           onPressed: () async {
//             cardsController.createNewCard();
//           },
//           isTextButton: true,
//           icon: const Icon(Icons.add),
//           label: "Create New Card",
//         ),
//       ],
//     );
//   }
// }
//
//
// class TemplateSelector extends AdaptiveUI{
//   @override
//   Widget view({required BuildContext ctx, required Adaptive adapter}) {
//     return ListView(
//       children: [
//         ...cardsController.templates.map((e) {
//           return SizedBox(
//             width: adapter.adapt(phone: 200, tablet: 180, desktop:400),
//             height:  adapter.adapt(phone: 300, tablet: 220, desktop: 600),
//             child: Container(
//               decoration: BoxDecoration(
//                 image:
//               ),
//               child: Card(
//                 shape: AppTheme.shape,
//                 child: Column(
//                   children: [
//                     Image.asset(),
//                     AppButton(onPressed: (){
//                       cardsController.cardInCreation(cardsController.cardInCreation.value.copyWith(template: e.id));
//                     },label: "Select",)
//                   ],
//                 ),
//               ),
//             ),
//           );
//         })
//       ],
//     );
//   }
//
// }