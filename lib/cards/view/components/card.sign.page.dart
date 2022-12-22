import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/cards/controller/cards.service.dart';
import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/cards/model/card.sign.dart';
import 'package:celebrated/cards/model/text.style.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/text.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
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

class CardSignPage extends AdaptiveUI {
  final CelebrationCard card;
  final CardSign signature;

  const CardSignPage({required this.signature, super.key, required this.card});

// With a MutableDocument, create a DocumentEditor, which knows how
// to apply changes to the MutableDocument.
  // final docEditor = ;
  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
      () {
        cardsController.birthdayCards.value;
        return Center(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            height: adapter.height,
            child: Scaffold(
              backgroundColor: Colors.white,
              bottomNavigationBar: PreferredSize(
                preferredSize: const Size(400, 60),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ...SigElementType.values.map((e) {
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: Builder(
                          builder: (BuildContext context) {
                            switch (e) {
                              case SigElementType.text:
                                return AppIconButton(
                                  icon: const Icon(Icons.text_fields),
                                  onPressed: () async {
                                    await createNewTextElement();
                                  },
                                );
                              case SigElementType.gif:
                                return AppIconButton(
                                  icon: const Icon(Icons.gif),
                                  onPressed: () async {
                                    await createNewGifElement(context);
                                  },
                                );
                            }
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              body: Center(
                child: SizedBox(
                  width: 400,
                  child: SuperEditor(
                    componentBuilders: [
                      ...defaultComponentBuilders,
                    ],
                    editor: DocumentEditor(
                        document: MutableDocument(
                      nodes: [
                        ...signature.elements.values.map((SignatureElement element) {
                          switch (element.type) {
                            case SigElementType.text:
                              return ParagraphNode(
                                id: DocumentEditor.createNodeId(),
                                text: AttributedText(text: element.value),
                                metadata: {
                                  'blockType': blockquoteAttribution,
                                },
                              );
                            case SigElementType.gif:
                              print(element.metadata.entries.map((e) => '\n\n${e.key}:${e.value}\n').toList().join(""));
                              return ImageNode(
                                id: DocumentEditor.createNodeId(),
                                metadata: {'blockType': blockquoteAttribution, ...element.toMap()},
                                imageUrl: element.metadata.toGif.images!.fixedHeight!.url,
                              );
                          }
                        }),
                      ],
                    )),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> saveElement(SignatureElement element) async {
    final CardSign newSign = signature.withElement(element);
    await cardsController.updateContent(
        card.id, {'signatures': card.withSignature(newSign).signatures.values.map((value) => value.toMap()).toList()});
  }

  Future<void> deleteElement(SignatureElement element) async {
    final CardSign newSign = signature.removeElement(element);
    await cardsController.updateContent(
        card.id, {'signatures': card.withSignature(newSign).signatures.values.map((value) => value.toMap()).toList()});
  }

  Future<void> createNewTextElement() async {
    final String id = IDGenerator.generateId(15, '${signature.id}text${card.id}');
    return await saveElement(SignatureElement.text(
        id: id,
        value: 'message \n\n - by unknown ',
        metadata: GoogleFonts.puppiesPlay(
                color: card.theme.foregroundColor, fontSize: 23, backgroundColor: card.theme.backgroundColor)
            .toMap()));
  }

  Future<void> createNewGifElement(context) async {
    final String id = IDGenerator.generateId(15, '${signature.id}text${card.id}gif');
    giffy = await GiphyGet.getGif(
      context: context,
      //Required
      apiKey: giffyAPIKey,
      //Required.
      lang: GiphyLanguage.english,
      //Optional - Language for query.
      randomID: "abcd",
      // Optional - An ID/proxy for a specific user.
      queryText: "birthday",
      tabColor: Colors.teal, // Optional- default accent color.
    );
    if (giffy != null && giffy!.url != null) {
      await saveElement(SignatureElement.gif(
        id: id,
        value: giffy!.url!,
        metadata: SignGiphyGif.fromGiffy(giffy!).toJson(),
      ));
    }
  }
}

class SignTextElement extends AdaptiveUI {
  final SignatureElement element;
  final Function(SignatureElement element) onSave;
  final Function(SignatureElement element) onDelete;
  static final RxString textInEdit = ''.obs;

  const SignTextElement({required this.onSave, required this.element, required this.onDelete, super.key});

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
        return Column(
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
        );
      },
    );
  }
}

class GifSignElement extends AdaptiveUI {
  final SignatureElement element;
  final Function(SignatureElement element) onSave;
  final Function(SignatureElement element) onDelete;

  const GifSignElement({required this.element, required this.onSave, required this.onDelete});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return GiphyGetWrapper(
        giphy_api_key: giffyAPIKey,
        builder: (stream, giphyGetWrapper) => StreamBuilder<GiphyGif>(
            stream: stream,
            initialData: element.metadata.toGif,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Column(
                      children: [
                        GiphyGifWidget(
                          imageAlignment: Alignment.center,
                          gif: element.metadata.toGif,
                          giphyGetWrapper: giphyGetWrapper,
                          borderRadius: BorderRadius.circular(30),
                          showGiphyLabel: true,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppIconButton(
                              onPressed: () async {
                                giffy = await GiphyGet.getGif(
                                  context: context,
                                  //Required
                                  apiKey: giffyAPIKey,
                                  //Required.
                                  lang: GiphyLanguage.english,
                                  //Optional - Language for query.
                                  randomID: "abcd",
                                  // Optional - An ID/proxy for a specific user.
                                  queryText: "birthday",
                                  tabColor: Colors.teal, // Optional- default accent color.
                                );
                                onSave(element.copyWith(metadata: giffy?.toJson()));
                              },
                              icon: const Icon(Icons.swap_vert),
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
                    )
                  : Text("No GIF");
            }));
  }
}

class ImageElementBuilder extends ComponentBuilder {
  @override
  Widget? createComponent(
      SingleColumnDocumentComponentContext componentContext, SingleColumnLayoutComponentViewModel componentViewModel) {
    if (componentViewModel is! ImageComponentViewModel) {
      return null;
    }

    return ImageComponent(
      componentKey: componentContext.componentKey,
      imageUrl: componentViewModel.imageUrl,
      selection: componentViewModel.selection,
      selectionColor: componentViewModel.selectionColor,
    );
  }

  @override
  SingleColumnLayoutComponentViewModel? createViewModel(Document document, DocumentNode node) {
    if (node is! ImageNode) {
      return null;
    }

    return ImageComponentViewModel(
      nodeId: node.id,
      imageUrl: node.imageUrl,
      selectionColor: const Color(0x00000000),
    );
  }
}

/// Displays an image in a document.
class ImageSignElement extends StatelessWidget {
  const ImageSignElement({
    Key? key,
    required this.componentKey,
    required this.imageUrl,
    this.selectionColor = Colors.blue,
    this.selection,
    this.imageBuilder,
  }) : super(key: key);

  final GlobalKey componentKey;
  final String imageUrl;
  final Color selectionColor;
  final UpstreamDownstreamNodeSelection? selection;

  /// Called to obtain the inner image for the given [imageUrl].
  ///
  /// This builder is used in tests to 'mock' an [Image], avoiding accessing the network.
  ///
  /// If [imageBuilder] is `null` an [Image] is used.
  final Widget Function(BuildContext context, String imageUrl)? imageBuilder;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      hitTestBehavior: HitTestBehavior.translucent,
      child: IgnorePointer(
        child: Center(
          child: SelectableBox(
            selection: selection,
            selectionColor: selectionColor,
            child: BoxComponent(
              key: componentKey,
              child: imageBuilder != null
                  ? imageBuilder!(context, imageUrl)
                  : Column(
                      children: [
                        Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppIconButton(
                              onPressed: () async {
                                giffy = await GiphyGet.getGif(
                                  context: context,
                                  //Required
                                  apiKey: giffyAPIKey,
                                  //Required.
                                  lang: GiphyLanguage.english,
                                  //Optional - Language for query.
                                  randomID: "abcd",
                                  // Optional - An ID/proxy for a specific user.
                                  queryText: "birthday",
                                  tabColor: Colors.teal, // Optional- default accent color.
                                );
                                onSave(element.copyWith(metadata: giffy?.toJson()));
                              },
                              icon: const Icon(Icons.swap_vert),
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
            ),
          ),
        ),
      ),
    );
  }

  CelebrationCard get card => cardsController.getCardById();

  Future<void> saveElement(SignatureElement element) async {
    final CardSign newSign = signature.withElement(element);
    await cardsController.updateContent(
        card.id, {'signatures': card.withSignature(newSign).signatures.values.map((value) => value.toMap()).toList()});
  }

  Future<void> deleteElement(SignatureElement element) async {
    final CardSign newSign = signature.removeElement(element);
    await cardsController.updateContent(
        card.id, {'signatures': card.withSignature(newSign).signatures.values.map((value) => value.toMap()).toList()});
  }
}

class ImageSignElementViewModel extends SingleColumnLayoutComponentViewModel {
  final SignatureElement signElement;

  ImageSignElementViewModel({
    required String nodeId,
    double? maxWidth,
    required this.signElement,
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    required this.imageUrl,
    this.selection,
    required this.selectionColor,
  }) : super(nodeId: nodeId, maxWidth: maxWidth, padding: padding);

  String get imageUrl => signElement.metadata.toGif;
  UpstreamDownstreamNodeSelection? selection;
  Color selectionColor;

  @override
  ImageSignElementViewModel copy() {
    return ImageSignElementViewModel(
      nodeId: nodeId,
      maxWidth: maxWidth,
      padding: padding,
      imageUrl: imageUrl,
      selection: selection,
      signElement: signElement,
      selectionColor: selectionColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is ImageComponentViewModel &&
          runtimeType == other.runtimeType &&
          nodeId == other.nodeId &&
          imageUrl == other.imageUrl &&
          selection == other.selection &&
          selectionColor == other.selectionColor;

  @override
  int get hashCode =>
      super.hashCode ^ nodeId.hashCode ^ imageUrl.hashCode ^ selection.hashCode ^ selectionColor.hashCode;
}

class SignGiphyGif {
  String? title;
  String? type;
  String? id;
  String url;
  String? rating;
  int? isSticker;
  int? width;
  int? height;

  SignGiphyGif({
    required this.title,
    required this.type,
    required this.id,
    required this.url,
    required this.rating,
    required this.width,
    required this.height,
    required this.isSticker,
  });

  factory SignGiphyGif.fromJson(Map<String, dynamic> json) => SignGiphyGif(
        title: json['title'],
        type: json['type'],
        id: json['id'],
        url: json['url'],
        rating: json['rating'],
        isSticker: json['is_sticker'] as int,
      );

  factory SignGiphyGif.fromGiffy(GiphyGif gif) {
    return SignGiphyGif(
        title: gif.title,
        type: gif.type,
        id: gif.id,
        url: gif.url!,
        rating: gif.rating,
        isSticker: gif.isSticker,
        width: gif.images.downsizedLarge.url,

        height: gif);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'type': type,
      'id': id,
      'url': url,
      'rating': rating,
      'is_sticker': isSticker,
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
