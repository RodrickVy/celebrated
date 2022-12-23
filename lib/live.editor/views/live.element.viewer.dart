import 'package:celebrated/app.theme.dart';
import 'package:celebrated/cards/view/components/card.sign.page.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/live.editor/controller/canvas.controller.dart';
import 'package:celebrated/live.editor/model/live.element.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Wrapper around an element that's in viewMode, not edit mode, if looking to toggle viewMode and Edit mode for an element use disabled property on LiveEditable.
class LiveEditorElementView extends AdaptiveUI {
  final LiveEditorCanvasController controller;
  final Rx<LiveEditorElement> element;
  final Function<T extends LiveEditorElement>({required LiveEditorCanvasController controller, required T element})
  elementWidgetBuilder;

  const LiveEditorElementView(
      {super.key, required this.controller, required this.elementWidgetBuilder, required this.element});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Positioned(
      top: element.value.posY,
      left: element.value.posX,
      child: Container(
        decoration: AppTheme.boxDecoration,
        width: element.value.width,
        height: element.value.height,
        child: elementWidgetBuilder(controller: controller, element: element.value),
      ),
    );
  }
}