import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/cards/controller/cards.service.dart';
import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/cards/model/card.sign.dart';
import 'package:celebrated/cards/model/text.style.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/editable.text.field.dart';
import 'package:celebrated/domain/view/components/text.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/main.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/id.generator.dart';
import 'package:celebrated/util/list.extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:text_editor/text_editor.dart';
import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/cards/controller/cards.service.dart';
import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/cards/model/card.sign.dart';
import 'package:celebrated/cards/view/components/card.back.page.dart';
import 'package:celebrated/cards/view/components/card.front.page.dart';
import 'package:celebrated/cards/view/components/card.sign.page.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/domain/view/pages/loading.dart';
import 'package:celebrated/domain/view/pages/task.stage.pages.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/id.generator.dart';
import 'package:celebrated/util/list.extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


String giffyAPIKey = "rcFrjQfPwLydblY9vsX6VuM6neiDLGRy";
GiphyGif? giffy;

class CardSignPage extends AdaptiveUI {
  final CelebrationCard card;
  final CardSign signature;

  const CardSignPage({required this.signature, super.key, required this.card});

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
              appBar: PreferredSize(
                preferredSize: const Size(400, 60),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const BodyText("Add"),
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
                  child: ListView(
                    padding: const EdgeInsets.all(30),
                    children: [
                      if (authService.userLive.value.uid == card.authorId)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: AppButton(
                            label: "Delete Page",
                            color: Colors.red,
                            onPressed: ()async {
                              await deleteSign();
                            },
                          ),
                        ),
                      ...signature.elements.values.map((SignatureElement element) {
                        switch (element.type) {
                          case SigElementType.text:
                            return SignTextElement(
                              onSave: (SignatureElement element) async {
                                await saveElement(element);
                              },
                              element: element,
                              onDelete: (SignatureElement element) async {
                                await deleteElement(element);
                              },
                            );
                          case SigElementType.gif:
                            return GifSignElement(
                              element: element,
                              onSave: (SignatureElement element) async {
                                await saveElement(element);
                              },
                              onDelete: (SignatureElement element) async {
                                await deleteElement(element);
                              },
                            );
                        }
                      }),
                      SizedBox(height: 260,)
                    ],
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

  Future<void> deleteSign() async {

    await cardsController.updateContent(
        card.id, {'signatures': card.withRemovedSignature(signature).signatures.values.map((value) => value.toMap()).toList()});
  }
  Future<void> createNewTextElement() async {
    final String id =IDGenerator.generateId(15, '${signature.id}text${card.id}');
    return await saveElement(SignatureElement.text(
        id:id ,
        value: 'message \n\n - by unknown ',
        metadata: GoogleFonts.puppiesPlay(
                color: card.theme.foregroundColor, fontSize: 23, backgroundColor: card.theme.backgroundColor)
            .toMap()));
  }

  Future<void> createNewGifElement(context) async {
    final String id =IDGenerator.generateId(15, '${signature.id}text${card.id}gif');
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
    if (giffy != null) {
      await saveElement(SignatureElement.gif(
          id: id,
          value: giffy!.title ?? '',
          metadata: giffy!.toJson()));
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
              height: adapter.adapt(phone: adapter.width, tablet: adapter.height - 150, desktop: (adapter.height / 3.5) * 1),
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
                          mainAxisAlignment:  MainAxisAlignment.center,
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



