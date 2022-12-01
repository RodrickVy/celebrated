import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';

abstract class AdaptiveUI extends StatelessWidget {


  const AdaptiveUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return view(ctx: context, adapter: Adaptive(context));
  }

  Widget view({required BuildContext ctx, required Adaptive adapter});
}
