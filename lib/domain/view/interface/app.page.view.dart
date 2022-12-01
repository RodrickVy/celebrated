import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/views/app.bottom.nav.bar.dart';
import 'package:celebrated/navigation/views/app.drawer.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';

/// much like [StatefulView] but this time for a page, adds a scaffold using the appWide [AppDesktopDrawer],[AppBottomNavBar]
/// to avoid the hustle of repeating calling them.
/// The scaffold uses [NavControllers]'s scaffoldKey to enable anyone to close and open drawer using [NavService]
abstract class AppPageView extends StatelessWidget {
  const AppPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return view(ctx: context, adapter: Adaptive(context));
  }


  Widget view({required BuildContext ctx, required Adaptive adapter});
}

