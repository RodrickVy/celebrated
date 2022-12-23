import 'package:celebrated/app.theme.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/live.editor/controller/canvas.controller.dart';
import 'package:celebrated/live.editor/model/live.element.dart';
import 'package:celebrated/live.editor/model/live.element.type.dart';
import 'package:celebrated/live.editor/views/live.element.viewer.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';

class LiveCanvasViewOnly extends AdaptiveUI {


  final  LiveEditorCanvasController controller;

  const LiveCanvasViewOnly({ required this.controller,super.key,});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        height: adapter.height,
        child: Center(
          child: SizedBox(
            width: 400,
            child: Card(
              shape: AppTheme.shape,
              child: ListView(
                padding: const EdgeInsets.all(30),
                children: [

                  ...controller.currentElements.map((LiveEditorElement element) {
                    final LiveEditorElementType? type = controller.elementType(element);
                    if (type != null) {
                      return LiveEditorElementView(
                          controller: controller,
                          elementWidgetBuilder: type.elementWidgetBuilder,
                          element: controller.trackElement(element.id));
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                  const SizedBox(height: 260,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
