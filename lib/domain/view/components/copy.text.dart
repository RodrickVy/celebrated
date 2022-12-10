// ignore_for_file: must_be_immutable

import 'package:celebrated/app.theme.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/app.text.field.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/view/feedback.spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class CopyText extends StatelessWidget {
  final String textValue;
  late Key _key;

  CopyText({Key? key, required this.textValue}) : super(key: key) {
    _key = key ?? Key(textValue.hashCode.toString());
  }

  @override
  Widget build(BuildContext context) {
    return FeedbackSpinner(
      spinnerKey: _key,
      child: Container(
        decoration: AppTheme.boxDecoration,
        child: Row(
          children: [
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SelectableText(textValue),
              ),
            ),
            AppIconButton(
                loadStateKey: FeedbackSpinKeys.appWide,
                onPressed: () async {
                  if (GetPlatform.isWeb) {
                    await Clipboard.setData(ClipboardData(text: textValue));
                    FeedbackService.clearErrorNotification();
                    FeedbackService.successAlertSnack('text copied!');
                  } else {
                    await Share.share(textValue);
                    FeedbackService.clearErrorNotification();
                  }
                },
                icon: Icon(GetPlatform.isWeb ? Icons.copy : Icons.share))
          ],
        ),
      ),
    );
    // return Obx(
    //   () => AnimatedSwitcher(
    //     duration: const Duration(milliseconds: 800),
    //     child:
    //
    //
    //     __editMode.value == true
    //         ? Row(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               IconButton(
    //                   onPressed: () {
    //                     __editMode(false);
    //                     onSave(_textEditingController.value.text);
    //                   },
    //                   icon: const Icon(
    //                     Icons.save,
    //                     color: Colors.black,
    //                     size: 18,
    //                   )),
    //               Flexible(
    //                 flex: 3,
    //                 child: AppTextField(
    //
    //                     controller: _textEditingController,
    //                     label: label,
    //                     minLines: minLines,
    //                     maxLines: maxLines ?? 1,
    //                     // maxLength: 200,
    //                     autoFocus: true,
    //                     hint: textValue),
    //               ),
    //
    //             ],
    //           )
    //         :Row(
    //       children: [
    //         IconButton(
    //           onPressed: () {
    //             __editMode(true);
    //           },
    //             padding: const EdgeInsets.only(bottom: 12.0),
    //           icon: const Icon(
    //             Icons.edit,
    //             color: Colors.black,
    //           )),
    //         Padding(
    //           padding: const EdgeInsets.all(2.0),
    //           child: Text(textValue),
    //         ),
    //
    //       ],
    //     )
    //   ),
    // );
  }
}
