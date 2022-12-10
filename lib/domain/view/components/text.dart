import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';

class Heading extends AdaptiveUI {
  final String title;
  final TextAlign textAlign;

  const Heading(this.title, {super.key, this.textAlign = TextAlign.center});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: adapter.textTheme.headlineSmall,
        textAlign: textAlign,
      ),
    );
  }
}

class BodyText extends AdaptiveUI {
  final String title;
  final TextAlign textAlign;

  const BodyText(this.title, {super.key, this.textAlign = TextAlign.center});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: adapter.textTheme.bodyMedium,
        textAlign: textAlign,
      ),
    );
  }
}

class SubheadingLined extends AdaptiveUI {
  final String title;

  const SubheadingLined(this.title, {super.key});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
        Heading(
         title,
          textAlign: TextAlign.left,
        ),
        const Divider(
          thickness: 0.5,
        ),
      ],
    );
  }
}
