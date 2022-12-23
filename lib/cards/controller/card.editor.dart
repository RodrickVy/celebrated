import 'package:celebrated/cards/controller/cards.service.dart';
import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/cards/model/card.sign.dart';
import 'package:celebrated/live.editor/controller/editor.controller.dart';
import 'package:celebrated/live.editor/data/element.types.dart';
import 'package:celebrated/live.editor/model/live.canvas.dart';
import 'package:celebrated/live.editor/model/live.element.type.dart';

class CelebrationCardsEditor with LiveEditorController {
  final CelebrationCard card;

  @override
  final List<LiveEditorCanvas> initialCanvases;

  CelebrationCardsEditor({required this.initialCanvases, required this.card}) {
    init();
  }

  @override
  Future<void> onSave(List<LiveEditorCanvas> canvases) async {
    await cardsController.updateContent(card.id, {
      "signatures": canvases.map((e) => CardSign.fromLiveCanvas(e).toMap()).toList(),
    });
  }

  @override
  List<LiveEditorElementType> elementTypes = [TextElementType()];
}
