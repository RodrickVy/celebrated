import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/live.editor/controller/canvas.controller.dart';
import 'package:celebrated/live.editor/model/live.element.dart';
import 'package:celebrated/live.editor/model/live.element.type.dart';
import 'package:celebrated/live.editor/views/live.editable.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// The view for a canvas
class LiveCanvas extends AdaptiveUI {
  final LiveEditorCanvasController controller;

  const LiveCanvas({required this.controller, super.key});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return LayoutBuilder(builder: (BuildContext ctx , BoxConstraints constraints ) {
      Size canvasSize = controller.canvasSizeOnScreen(Size(constraints.maxWidth,constraints.maxHeight));
      return   Container(
        padding:  EdgeInsets.zero,
        margin: EdgeInsets.zero,
        height:canvasSize.height,
        width:canvasSize.width,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          color: Colors.white
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: PreferredSize(
            preferredSize: const Size(400, 60),
            child: Obx(
                  () {
                    controller.trackableElements;
                    return Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (controller.elementInFocus == null)
                    ...controller.elementTypes.map((LiveEditorElementType type) {
                      return IconButton(
                          icon: CircleAvatar(
                            radius: 20,
                            child: Image.asset(type.icon),
                          ),
                          onPressed: () {
                            controller.addElement(type);
                          });
                    }),
                    ...controller.elementTypes.map((LiveEditorElementType type) {
                      if (controller.elementInFocus != null && controller.elementInFocus!.type == type.name) {
                        return type.editControlsBuilder<LiveEditorElement>(
                            controller: controller, element: controller.elementInFocus!);
                      }
                      return const SizedBox.shrink();
                    }),
                ],
              );
                  },
            ),
          ),
          body: Obx(
              ()=> Stack(
              children: [
                ...controller.trackableElements.values.map((Rx<LiveEditorElement> trackableElement) {
                  final LiveEditorElementType? type = controller.elementType(trackableElement.value);
                  if (type != null) {
                    return LiveEditable(
                        controller: controller,
                        elementWidgetBuilder: type.elementWidgetBuilder,
                        element:trackableElement);
                  } else {
                    return const SizedBox.shrink();
                  }
                })
              ],
            ),
          ),
        ),
      );
    });

  }
}