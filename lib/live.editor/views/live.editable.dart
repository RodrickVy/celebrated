import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/cards/model/card.theme.dart';
import 'package:celebrated/cards/view/components/card.sign.page.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/live.editor/controller/canvas.controller.dart';
import 'package:celebrated/live.editor/model/live.element.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Wraps around an element's widget to make it editable,
/// giving it functionality like dragging, resize and more.
class LiveEditable extends AdaptiveUI {
  final LiveEditorCanvasController controller;
  final Rx<LiveEditorElement> element;
  final bool disabled;
  final Function<T extends LiveEditorElement>({required LiveEditorCanvasController controller, required T element})
      elementWidgetBuilder;

  /// to toggle the color of which corner is being edited
  static final RxInt _cornerInEdit = 20.obs;

  const LiveEditable(
      {super.key,
      this.disabled = false,
      required this.controller,
      required this.elementWidgetBuilder,
      required this.element});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    /// Todo move the updating of position and size to the [LiveEditorElementType]  class
    /// This is so , each element can choose react to resizing and repositioning differently depending on its type.
    return Obx(
      () {
        return Positioned(
          top: element.value.posY,
          left: element.value.posX,
          child: GestureDetector(
            onTap: () {
              if (!disabled) {
                controller.focusElement(element.value.id);
              }
            },
            onPanStart: (details) {
              if (!disabled) {
                controller.focusElement(element.value.id);
              }
            },
            onPanUpdate: (details) {
              if (!disabled) {
                final XYPair currentPosition = element.value.position;
                controller.updateElement(element.value.copyWith(
                    posX: currentPosition.xValue + details.delta.dx, posY: currentPosition.yValue + details.delta.dy));
              }
            },
            onPanEnd: (details) {
              if (!disabled) {
                controller.saveCanvas();
              }
            },
            child: Stack(
              children: [
                SizedBox(
                  width: element.value.width+10,
                  height: element.value.height+10,
                ),
                Container(
                  decoration: AppTheme.boxDecoration,
                  width: element.value.width,
                  height: element.value.height,
                  child: elementWidgetBuilder(controller: controller, element: element.value),
                ),
                if (LiveEditorCanvasController.focusedElementId.value == element.value.id && !disabled)
                  Positioned(
                    right: 0,
                    height: element.value.height,
                    child: GestureDetector(
                      onPanStart: (details){
                        _cornerInEdit(3);
                      },
                      onPanEnd: (detials){
                        _cornerInEdit(20);
                      },
                      onPanUpdate: (details) {
                        if (!disabled) {
                          controller.updateElement(element.value.copyWith(
                            width: element.value.width + details.delta.dx,));
                        }
                      },
                      child: Obx(
                        ()=> Container(
                          width: 5,
                          height: element.value.height ,
                          color: _cornerInEdit.value == 3? AppSwatch.primary:Colors.black,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class DragSelectors{
  @override
  List<Widget> view({required BuildContext ctx, required Adaptive adapter}) {
   return [];
  }

}