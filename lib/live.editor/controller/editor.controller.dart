
import 'package:celebrated/live.editor/controller/canvas.controller.dart';
import 'package:celebrated/live.editor/model/live.canvas.dart';
import 'package:celebrated/live.editor/model/live.element.type.dart';
import 'package:get/get.dart';

/// Controls canvases being edited
/// Wraps each canvas inside its controller, giving you a list of controllers
/// you can simply loop over to show each canvas.
mixin LiveEditorController {
  final RxMap<String, LiveEditorCanvasController> controllers = <String, LiveEditorCanvasController>{}.obs;

  /// initial data
  List<LiveEditorCanvas> get initialCanvases;

  List<LiveEditorElementType> get elementTypes;

  /// the only method to save data else where, like db etc.
  Future<void> onSave(List<LiveEditorCanvas> canvases);

  /// used to create a canvas Controller
  LiveEditorCanvasController createController(LiveEditorCanvas canvas) {
    return LiveEditorCanvasController(
        elementTypes: elementTypes,
        canvas: canvas,
        onDeleteCanvas: (canvas, __) async {
          return removeCanvas(canvas);
        },
        onSaveCanvas: (_, __) async {
          return _save();
        });
  }

  /// Transforms the list of canvases to controllers for each canvas
  Map<String, LiveEditorCanvasController> canvasesToControllers(
      List<LiveEditorCanvas> canvases, List<LiveEditorElementType> types) {
    return canvases
        .map((e) => MapEntry(e.id, createController(e)))
        .fold({}, (previousValue, element) => {...previousValue, element.key: element.value});
  }

  /// Make sure to call this on construction
  init() {
    controllers.addAll(canvasesToControllers(initialCanvases, elementTypes));
  }

  /// adds a new  canvas
  addCanvas(LiveEditorCanvas canvas) {
    controllers[canvas.id] = createController(canvas);

    _save();
  }

  /// The latest Canvases as found in each controller
  List<LiveEditorCanvas> get canvases => controllers.values.map((e) => e.currentCanvas).toList();

  Future<bool> _save() async {
    await onSave(canvases);
    return true;
  }

  removeCanvas(LiveEditorCanvas canvas) {
    controllers.remove(canvas.id);
    _save();
  }
}