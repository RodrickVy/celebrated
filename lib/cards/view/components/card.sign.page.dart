import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/cards/adapter/card.factory.dart';
import 'package:celebrated/cards/controller/cards.service.dart';
import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/cards/model/card.sign.dart';
import 'package:celebrated/cards/model/card.theme.dart';
import 'package:celebrated/cards/model/text.style.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/text.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/live.editor/controller/canvas.controller.dart';
import 'package:celebrated/live.editor/model/live.element.dart';
import 'package:celebrated/live.editor/model/live.element.type.dart';
import 'package:celebrated/live.editor/views/live.canvas.edit.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/id.generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_editor/super_editor.dart';
import 'package:text_editor/text_editor.dart';

String giffyAPIKey = "rcFrjQfPwLydblY9vsX6VuM6neiDLGRy";
GiphyGif? giffy;

// class CardSignPage extends AdaptiveUI {
//   final LiveEditorCanvasController controller;
//
//   const CardSignPage({
//     required this.controller,
//     super.key,
//   });
//
//   // With a MutableDocument, create a DocumentEditor, which knows how
//   // to apply changes to the MutableDocument.
//   // final docEditor = ;
//   @override
//   Widget view({required BuildContext ctx, required Adaptive adapter}) {
//
//     // return Obx(
//     //   () {
//     //     cardsController.birthdayCards.value;
//     //     return Center(
//     //       child: Container(
//     //         padding: const EdgeInsets.all(12.0),
//     //         height: adapter.height,
//     //         child: Scaffold(
//     //           backgroundColor: Colors.white,
//     //           bottomNavigationBar: PreferredSize(
//     //             preferredSize: const Size(400, 60),
//     //             child: Obx(
//     //               () => Wrap(
//     //                 crossAxisAlignment: WrapCrossAlignment.center,
//     //                 children: [
//     //                   if (currentElementInEdit.value == null)
//     //                     ...SigElementType.values.map((e) {
//     //                       return Padding(
//     //                         padding: const EdgeInsets.all(12),
//     //                         child: Builder(
//     //                           builder: (BuildContext context) {
//     //                             switch (e) {
//     //                               case SigElementType.text:
//     //                                 return AppIconButton(
//     //                                   icon: const Icon(Icons.text_fields),
//     //                                   onPressed: () async {
//     //                                     await createNewTextElement();
//     //                                   },
//     //                                 );
//     //                               case SigElementType.image:
//     //                                 return AppIconButton(
//     //                                   icon: const Icon(Icons.gif),
//     //                                   onPressed: () async {
//     //                                     await createNewImageElement(context);
//     //                                   },
//     //                                 );
//     //                             }
//     //                           },
//     //                         ),
//     //                       );
//     //                     }),
//     //                   if (currentElementInEdit.value != null &&
//     //                       currentElementInEdit.value!.type == SigElementType.image)
//     //                     ImageElementControls(
//     //                       onDone: () {
//     //                         currentElementInEdit.value = null;
//     //                       },
//     //                       element: currentElementInEdit.value!,
//     //                       onSave: saveElement,
//     //                       onDelete: deleteElement,
//     //                     )
//     //                 ],
//     //               ),
//     //             ),
//     //           ),
//     //           body: Center(
//     //             child: SizedBox(
//     //                 width: 400,
//     //                 child: Stack(
//     //                   children: [
//     //                     ...signature.elements.values.map((LiveEditorElement element) {
//     //                       switch (element.type) {
//     //                         case SigElementType.text:
//     //                           return TextElementViewer(
//     //                             onDelete: deleteElement,
//     //                             onSave: saveElement,
//     //                             element: element,
//     //                           );
//     //
//     //                         case SigElementType.image:
//     //                           return PositionedImageElement(
//     //                             onFocused: focusElement,
//     //                             onDelete: deleteElement,
//     //                             onSave: saveElement,
//     //                             element: element,
//     //                           );
//     //                       }
//     //                     }),
//     //                   ],
//     //                 )
//     //
//     //                 // SuperEditor(
//     //                 //   composer: DocumentComposer(
//     //                 //     imeConfiguration: const ImeConfiguration(enableAutocorrect: true,enableSuggestions: true, keyboardActionButton: TextInputAction.done),
//     //                 //   ),
//     //                 //   componentBuilders:  [
//     //                 //      BlockquoteComponentBuilder(),
//     //                 //      ParagraphComponentBuilder(),
//     //                 //      ListItemComponentBuilder(),
//     //                 //      ImageElementBuilder(),
//     //                 //      HorizontalRuleComponentBuilder(),
//     //                 //   ],
//     //                 //   editor: DocumentEditor(
//     //                 //       document: MutableDocument(
//     //                 //     nodes: [
//     //                 //       ...signature.elements.values.map((SignatureElement element) {
//     //                 //         switch (element.type) {
//     //                 //           case SigElementType.text:
//     //                 //             return ParagraphNode(
//     //                 //               id: DocumentEditor.createNodeId(),
//     //                 //               text: AttributedText(text: element.value),
//     //                 //               metadata: {
//     //                 //                 'blockType': blockquoteAttribution,
//     //                 //               },
//     //                 //             );
//     //                 //           case SigElementType.gif:
//     //                 //             return ImageNode(
//     //                 //               id: DocumentEditor.createNodeId(),
//     //                 //               metadata: {
//     //                 //                 'blockType': blockquoteAttribution,
//     //                 //                 'element': element.toMap(),
//     //                 //                 'signature': signature.toMap(),
//     //                 //                 'card': CelebrationCardFactory().toJson(card)
//     //                 //               },
//     //                 //               altText: element.metadata.toGif.title??'gif from giffy',
//     //                 //               imageUrl: element.metadata.toGif.url,
//     //                 //             );
//     //                 //         }
//     //                 //       }),
//     //                 //     ],
//     //                 //   )),
//     //                 // ),
//     //                 ),
//     //           ),
//     //         ),
//     //       ),
//     //     );
//     //   },
//     // );
//   }
// //
// // Future<void> saveElement(LiveEditorElement element) async {
// //   final CardSign newSign = signature.withElement(element);
// //   await cardsController.updateContent(
// //       card.id, {'signatures': card.withSignature(newSign).signatures.values.map((value) => value.toMap()).toList()});
// // }
// //
// // Future<void> deleteElement(LiveEditorElement element) async {
// //   final CardSign newSign = signature.removeElement(element);
// //   await cardsController.updateContent(
// //       card.id, {'signatures': card.withSignature(newSign).signatures.values.map((value) => value.toMap()).toList()});
// // }
// //
// // Future<void> createNewTextElement() async {
// //   final String id = IDGenerator.generateId(15, '${signature.id}text${card.id}');
// //   return await saveElement(LiveEditorElement.text(
// //       id: id,
// //       value: 'message \n\n - by unknown ',
// //       metadata: GoogleFonts.puppiesPlay(
// //               color: card.theme.foregroundColor, fontSize: 23, backgroundColor: card.theme.backgroundColor)
// //           .toMap()));
// // }
// //
// // Future<void> createNewImageElement(context) async {
// //   final String id = IDGenerator.generateId(15, '${signature.id}text${card.id}gif');
// //   giffy = await GiphyGet.getGif(
// //     context: context,
// //     //Required
// //     apiKey: giffyAPIKey,
// //     //Required.
// //     lang: GiphyLanguage.english,
// //     //Optional - Language for query.
// //     randomID: "abcd",
// //     // Optional - An ID/proxy for a specific user.
// //     queryText: "birthday",
// //     tabColor: Colors.teal, // Optional- default accent color.
// //   );
// //   if (giffy != null && giffy!.url != null) {
// //     final SignElementImage image = SignElementImage.fromGiffy(giffy!);
// //     await saveElement(LiveEditorElement(
// //       id: id,
// //       value: giffy!.url!,
// //       metadata: image.toJson(),
// //       width: image.width,
// //       height: image.height,
// //       posX: signature.unUsedPosition.xValue,
// //       posY: signature.unUsedPosition.yValue,
// //       type: SigElementType.image,
// //     ));
// //   }
// // }
// //
// // void focusElement(LiveEditorElement element) {
// //   currentElementInEdit(element);
// // }
// }
//











class TextElementViewer extends AdaptiveUI {
  final LiveEditorElement element;
  final Function(LiveEditorElement element) onSave;
  final Function(LiveEditorElement element) onDelete;
  static final RxString textInEdit = ''.obs;

  const TextElementViewer({required this.onSave, required this.element, required this.onDelete, super.key});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
      () {
        if (textInEdit.value == element.id) {
          return Card(
            shape: AppTheme.shape,
            color: Colors.black,
            child: SizedBox(
              height: adapter.adapt(
                  phone: adapter.width, tablet: adapter.height - 150, desktop: (adapter.height / 3.5) * 1),
              width: adapter.adapt(
                  phone: adapter.width - 20, tablet: adapter.width - 100, desktop: (adapter.width / 3) * 1),
              child: TextEditor(
                fonts: GoogleFonts.asMap()
                    .values
                    .toList()
                    .sublist(0, 10)
                    .map((TextStyle Function() e) => e().fontFamily ?? '')
                    .toList(),
                text: element.value,
                minFontSize: 20,
                maxFontSize: 40,
                textStyle: element.metadata.asTextStyle,
                textAlingment: TextAlign.center,
                onEditCompleted: (TextStyle style, align, message) async {
                  onSave(element.copyWith(metadata: {...style.toMap(), "align": align.name}, value: message));
                  textInEdit('');
                },
              ),
            ),
          );
        }
        return Draggable(
          feedback: Opacity(
            opacity: 0.2,
            child: image,
          ),
          child: image,
        );
      },
    );
  }

  Widget get image {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            element.value,
            style: element.metadata.asTextStyle,
            textAlign: element.metadata.asAlignment,
          ),
          Row(
            mainAxisAlignment: element.metadata.asAlignment == TextAlign.left
                ? MainAxisAlignment.start
                : element.metadata.asAlignment == TextAlign.right
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.center,
            children: [
              AppIconButton(
                onPressed: () {
                  textInEdit(element.id);
                },
                icon: const Icon(Icons.edit),
              ),
              AppIconButton(
                onPressed: () {
                  onDelete(element);
                },
                icon: const Icon(Icons.delete),
              )
            ],
          )
        ],
      ),
    );
  }
}
//
// class GifSignElement extends AdaptiveUI {
//   final SignatureElement element;
//   final Function(SignatureElement element) onSave;
//   final Function(SignatureElement element) onDelete;
//
//   const GifSignElement({required this.element, required this.onSave, required this.onDelete});
//
//   @override
//   Widget view({required BuildContext ctx, required Adaptive adapter}) {
//     return GiphyGetWrapper(
//         giphy_api_key: giffyAPIKey,
//         builder: (stream, giphyGetWrapper) => StreamBuilder<GiphyGif>(
//             stream: stream,
//             initialData: element.metadata.toGif,
//             builder: (context, snapshot) {
//               return snapshot.hasData
//                   ? Column(
//                       children: [
//                         GiphyGifWidget(
//                           imageAlignment: Alignment.center,
//                           gif: element.metadata.toGif,
//                           giphyGetWrapper: giphyGetWrapper,
//                           borderRadius: BorderRadius.circular(30),
//                           showGiphyLabel: true,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             AppIconButton(
//                               onPressed: () async {
//                                 giffy = await GiphyGet.getGif(
//                                   context: context,
//                                   //Required
//                                   apiKey: giffyAPIKey,
//                                   //Required.
//                                   lang: GiphyLanguage.english,
//                                   //Optional - Language for query.
//                                   randomID: "abcd",
//                                   // Optional - An ID/proxy for a specific user.
//                                   queryText: "birthday",
//                                   tabColor: Colors.teal, // Optional- default accent color.
//                                 );
//                                 onSave(element.copyWith(metadata: giffy?.toJson()));
//                               },
//                               icon: const Icon(Icons.swap_vert),
//                             ),
//                             AppIconButton(
//                               onPressed: () {
//                                 onDelete(element);
//                               },
//                               icon: const Icon(Icons.delete),
//                             )
//                           ],
//                         )
//                       ],
//                     )
//                   : Text("No GIF");
//             }));
//   }
// }





/// Displays an image in a document.
class PositionedImageElement extends AdaptiveUI {
  final LiveEditorElement element;

  /// when the element is clicked on
  final Function(LiveEditorElement element) onFocused;
  final Function(LiveEditorElement element) onSave;
  final Function(LiveEditorElement element) onDelete;

  static final Map<String, Rx<XYPair>> _imagePositions = <String, Rx<XYPair>>{};
  final RxBool isFocused = false.obs;

  PositionedImageElement(
      {Key? key, required this.onFocused, required this.element, required this.onSave, required this.onDelete})
      : super(key: key) {
    if (!_imagePositions.containsKey(element.id)) {
      _imagePositions[element.id] = element.position.obs;
    }
  }

  XYPair get currentPosition => _imagePositions[element.id]?.value ?? element.position;

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
      () {
        return Positioned(
          top: currentPosition.yValue,
          left: currentPosition.xValue,
          child: GestureDetector(
            onTap: () {
              onFocused(element);
              isFocused(true);
            },
            onPanStart: (details) {
              onFocused(element);
              isFocused(true);
            },
            onPanUpdate: (details) {
              _imagePositions[element.id]!(
                  XYPair(currentPosition.xValue + details.delta.dx, currentPosition.yValue + details.delta.dy));
            },
            onPanEnd: (details) {
              onSave(element.copyWith(posY: currentPosition.yValue, posX: currentPosition.xValue));
              isFocused(false);
            },
            child: Container(
              decoration: AppTheme.boxDecoration.copyWith(
                  border: isFocused.value
                      ? const Border.fromBorderSide(BorderSide(width: 2, color: Colors.black, style: BorderStyle.solid))
                      : null),
              width: element.width,
              height: element.height,
              child: Image.network(
                element.metadata.toImage.url,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}

class ImageElementControls extends AdaptiveUI {
  final LiveEditorElement element;
  final Function(LiveEditorElement element) onSave;
  final Function(LiveEditorElement element) onDelete;
  final Function() onDone;

  const ImageElementControls(
      {super.key, required this.onDone, required this.element, required this.onSave, required this.onDelete});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppIconButton(
          onPressed: () async {
            giffy = await GiphyGet.getGif(
              context: ctx,
              //Required
              apiKey: giffyAPIKey,
              //Required.
              lang: GiphyLanguage.english,
              //Optional - Language for query.
              randomID: "abcd",
              // Optional - An ID/proxy for a specific user.
              queryText: "birthday",
              tabColor: AppSwatch.primary, // Optional- default accent color.
            );
            if (giffy != null && giffy!.images != null) {
              final SignElementImage image = SignElementImage.fromGiffy(giffy!);
              onSave(element.copyWith(metadata: image.toJson(), width: image.width, height: image.height));
            }
          },
          icon: const Icon(Icons.swap_vert),
        ),
        AppIconButton(
          onPressed: () {
            onDelete(element);
            onDone();
          },
          icon: const Icon(Icons.delete),
        ),
        AppIconButton(
          onPressed: () {
            onDone();
          },
          icon: const Icon(Icons.done),
        ),
      ],
    );
  }
}

class SignElementImage {
  String? title;
  String? type;
  String? id;
  String url;
  String? rating;
  int? isSticker;
  double width;
  double height;

  SignElementImage({
    required this.title,
    required this.type,
    required this.id,
    required this.url,
    required this.rating,
    required this.width,
    required this.height,
    required this.isSticker,
  });

  factory SignElementImage.fromJson(Map<String, dynamic> json) => SignElementImage(
        title: json['title'],
        type: json['type'],
        id: json['id'],
        url: json['url'],
        rating: json['rating'],
        isSticker: json['is_sticker'],
        width: json['width'] ?? 120,
        height: json['height'] ?? 60,
      );

  factory SignElementImage.fromGiffy(GiphyGif gif) {
    return SignElementImage(
        title: gif.title,
        type: gif.type,
        id: gif.id,
        url: gif.images!.fixedWidth.url,
        rating: gif.rating,
        isSticker: gif.isSticker,
        width: double.parse(gif.images!.fixedWidth.width),
        height: double.parse(gif.images!.fixedWidth.height));
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'type': type,
      'id': id,
      'url': url,
      'rating': rating,
      'is_sticker': isSticker,
      'width': width,
      'height': height
    };
  }

  @override
  String toString() {
    return 'SignGiphyGif{title: $title, type: $type, id: $id, rating: $rating, isSticker: $isSticker}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GiphyGif &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          type == other.type &&
          id == other.id &&
          url == other.url &&
          rating == other.rating &&
          isSticker == other.isSticker;

  @override
  int get hashCode =>
      title.hashCode ^ type.hashCode ^ id.hashCode ^ url.hashCode ^ rating.hashCode ^ isSticker.hashCode;
}
