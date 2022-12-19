import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';

class CardBackPage extends AdaptiveUI {
  final CelebrationCard card;
  final double width;
  final double height;

  const CardBackPage({super.key, required this.card, required this.width, required this.height});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return LayoutBuilder(builder: (BuildContext ctx , BoxConstraints constraints ) {
      Size cardSize = card.theme.computeSizeFromRatio(Size(constraints.maxWidth,constraints.maxHeight));
      return SizedBox(
        width: cardSize.width,
        height: cardSize.height,
        child: Image.network(
          card.theme.cardBack,
          width: cardSize.width,
          height: cardSize.height,
        ),
      );
    },);


  }
}
// if (card.theme.hasBackImage) {
//   return Container(
//     decoration: BoxDecoration(
//         image: card.hasBackgroundImage
//             ? DecorationImage(
//                 image: AssetImage(card.theme.cardFront),
//                 fit: BoxFit.cover,
//               )
//             : null),
//     child: Card(
//         elevation: 2,
//         shape: AppTheme.shape,
//         clipBehavior: Clip.hardEdge,
//         color: card.theme.backgroundColor,
//         child: Image.asset(
//           card.theme.backImage,
//           fit: BoxFit.fitWidth,
//         )),
//   );
// } else {
//   return Container(
//     decoration: AppTheme.boxDecoration.copyWith(
//         image: card.hasBackgroundImage
//             ? DecorationImage(
//                 image: AssetImage(card.theme.cardFront),
//                 fit: BoxFit.cover,
//               )
//             : null),
//     child: Card(
//       elevation: card.hasBackgroundImage ? 0 : 2,
//       shape: AppTheme.shape,
//       clipBehavior: Clip.hardEdge,
//       color: card.hasBackgroundImage ? Colors.transparent : card.theme.backgroundColor,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(
//             height: 65,
//           ),
//           if (card.theme.topImage.isNotEmpty)
//             Opacity(
//               opacity: 0,
//               child: Container(
//                 height: (height / 4) * 2,
//                 alignment: card.theme.topImageAlignment,
//                 padding: const EdgeInsets.all(8.0),
//                 child: Image.asset(
//                   card.theme.topImage,
//                   fit: BoxFit.fitHeight,
//                 ),
//               ),
//             ),
//           const SizedBox(
//             height: 100,
//           )
//         ],
//       ),
//     ),
//   );
// }