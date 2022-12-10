
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class CardPreview extends AdaptiveUI {
  final BirthdayCard card;

  const CardPreview(
      {Key? key,
      required this.card,
     })
      : super(key: key);
  
  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return SizedBox(
      width: adapter.adapt(phone: 200, tablet: 180, desktop:400),
      height:  adapter.adapt(phone: 300, tablet: 220, desktop: 600),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child:  Card(
            elevation: 0,
            shape: AppTheme.shape,
            child: ListTile(
              onTap: () {
                navService.to("${AppRoutes.cards}/edit/${card.id}");
              },
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child:   Text(
                  card.title,
                  style: Adaptive(ctx).textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.w600, fontFamily: GoogleFonts.playfairDisplay().fontFamily),
                ),
              ),
              subtitle:  Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    card.title,
                    style: Adaptive(ctx).textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.w600, fontFamily: GoogleFonts.playfairDisplay().fontFamily),
                  ),
                  const SizedBox(width: 10,),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      card.from,
                      style: Adaptive(ctx).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(card.to),
                ],
              ),

            )),
      ),
    );
  }

  /// use of routes, we are using routes for two things , one is to store the current list and now its to get the current birthday in edit mode.
}
