import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/domain/view/app.state.view.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:get/get.dart';

class AvatarEditorView extends AppStateView<AuthController> {
  AvatarEditorView({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FluttermojiCircleAvatar(
            radius: 80,
          ),
        ),
        FluttermojiSaveWidget(),
        FluttermojiCustomizer(
          scaffoldHeight: Get.height - 300,
          scaffoldWidth: Get.width,
          autosave: false,
        ),
      ],
    );
  }
}
