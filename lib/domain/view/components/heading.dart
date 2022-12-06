import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';

class Heading extends AdaptiveUI{
  final String  title;

  const Heading(this.title, {super.key});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title, style: adapter.textTheme.headlineSmall),
    );
  }


}