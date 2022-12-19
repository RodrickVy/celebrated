import 'package:celebrated/app.theme.dart';
import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/cards/model/card.theme.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';

class CardFrontPage extends AdaptiveUI {
  final CelebrationCard card;
  final double? width;
  final double? height;

  const CardFrontPage({super.key, required this.card,  this.width,  this.height});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return LayoutBuilder(builder: (BuildContext ctx , BoxConstraints constraints ) {
      Size cardSize = card.theme.computeSizeFromRatio(Size(constraints.maxWidth,constraints.maxHeight));
      XYPair textPosition = card.theme.computeTextXYPosition(cardSize);
      return SizedBox(
        width: cardSize.width,
        height: cardSize.height,
        child: Stack(
          children: [
            SizedBox(
              width: cardSize.width,
              height: cardSize.height,
              child: Image.network(
                card.theme.cardFront,
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned.fill(
              top: 0,
              left: 0,
              child: SizedBox(
                width: cardSize.width,
                height: cardSize.height,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      margin: EdgeInsets.only(left: textPosition.xValue, top: textPosition.yValue),
                      width: cardSize.width -textPosition.xValue,
                      padding: const EdgeInsets.all(8),
                      decoration: AppTheme.boxDecoration.copyWith(
                        color: card.theme.textStyle.backgroundColor,
                        border: const Border.fromBorderSide(BorderSide.none)
                      ),

                      child: Text(
                        card.to,
                        style: card.theme.textStyle.toMaterial.copyWith(backgroundColor: Colors.transparent,fontSize: cardSize.width*0.04),
                        textAlign: card.theme.textStyle.textAlignment,
                      )),
                ),
              ),
            )
          ],
        ),
      );
    },);
  }
}
// }
// return SizedBox(
// width: width,
// height: height,
// child: Builder(builder: (xtz) {
// if (card.theme.hasFrontImage) {
// return Container(
// decoration: BoxDecoration(
// image: card.hasBackgroundImage
// ? DecorationImage(
// image: AssetImage(card.theme.cardFront),
// fit: BoxFit.cover,
// )
//     : null),
// child: Card(
// elevation: 2,
// shape: AppTheme.shape,
// clipBehavior: Clip.hardEdge,
// color: card.theme.backgroundColor,
// child: Image.asset(
// card.theme.frontImage,
// fit: BoxFit.fitWidth,
// )),
// );
// } else {
// return Container(
// decoration: AppTheme.boxDecoration.copyWith(
// image: card.hasBackgroundImage
// ? DecorationImage(
// image: AssetImage(card.theme.cardFront),
// fit: BoxFit.cover,
// )
//     : null),
// child: Card(
// elevation: card.hasBackgroundImage ? 0:2,
// shape: AppTheme.shape,
// clipBehavior: Clip.hardEdge,
// color: card.hasBackgroundImage ? Colors.transparent : card.theme.backgroundColor,
// child: Stack(
// children: [
//
// if (card.theme.topTitle.isNotEmpty)
// Container(
// alignment: Alignment.topCenter,
// padding: const EdgeInsets.all(20).copyWith(top: 40),
// child: Text(
// card.theme.topTitle,
// style: GoogleFonts.playfairDisplay(fontSize: 24, color: card.theme.foregroundColor)
//     .copyWith(fontFamily: card.theme.fontFamily, fontWeight: FontWeight.bold),
// ),
// ),
// if (card.theme.topImage.isNotEmpty)
// Container(
// width: adapter.width,
// alignment: card.theme.topImageAlignment,
// padding: const EdgeInsets.all(8.0).copyWith(top:100),
// child: Image.asset(
// card.theme.topImage,
// height: (height/4)*2,
// ),
// ),
// Column(
// mainAxisSize: MainAxisSize.min,
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
// if (card.theme.topImage.isNotEmpty)
// Opacity(
// opacity: 0,
// child: Container(
// height: (height/4)*2,
// alignment: card.theme.topImageAlignment,
// padding: const EdgeInsets.all(8.0),
// width: (adapter.width / 4) * 3.4),
// ),
// Text(
// card.to.toUpperCase(),
// style: GoogleFonts.playfairDisplay(fontSize: adapter.adapt(phone: 25, tablet: 28, desktop: 30), color: card.theme.foregroundColor)
//     .copyWith(fontFamily: card.theme.fontFamily, fontWeight: FontWeight.w900),
// ),
// const SizedBox(
// width: 10,
// ),
// Padding(
// padding: const EdgeInsets.only(right: 8.0,top: 10),
// child: Text(
// "from :  ${card.from}",
// style: Adaptive(ctx)
//     .textTheme
//     .bodyMedium
//     ?.copyWith(fontWeight: FontWeight.w400,fontFamily: card.theme.fontFamily,fontSize: adapter.adapt(phone: 17, tablet: 20, desktop: 24),  color: card.theme.foregroundColor),
// ),
// ),
// const SizedBox(
// height: 100,
// )
// ],
// ),
// ],
// )),
// );
// }
// }),
/// );
