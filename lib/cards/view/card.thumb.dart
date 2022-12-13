
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/domain/model/drop.down.action.dart';
import 'package:celebrated/domain/view/components/text.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class CardPreview extends AdaptiveUI {
  final BirthdayCard card;
  List<OptionAction> get actions => [
    OptionAction("Delete", Icons.delete, () async {

    }),
    OptionAction("Edit", Icons.edit, () async {

    }),
    OptionAction("Preview", Icons.remove_red_eye_sharp, () {

    })
  ];
  const CardPreview(
      {Key? key,
      required this.card,
     })
      : super(key: key);
  
  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return SizedBox(
      width: adapter.adapt(phone: 200, tablet: 180, desktop:200),
      height:  adapter.adapt(phone: 300, tablet: 220, desktop: 300),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child:  Card(
            elevation: 0,
            shape: AppTheme.shape,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Heading(
                    card.title,
                  ),
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
                const Spacer(),
                Container(
                  width: 300,
                  height: 60,
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    children: [
                      ...actions.map((e) => IconButton(onPressed: e.action, icon: Icon(e.icon),))
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  /// use of routes, we are using routes for two things , one is to store the current list and now its to get the current birthday in edit mode.
}
