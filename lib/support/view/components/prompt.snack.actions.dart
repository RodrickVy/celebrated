import 'package:celebrated/app.theme.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:flutter/material.dart';

class PromptSnackActions extends StatelessWidget {
  final Function onAction;
  final Function onCancel;
  final String actionLabel;
  final String cancelLabel;

  const PromptSnackActions({
    Key? key,
    required this.onAction,
    required this.onCancel,
    this.actionLabel = "Delete",
    this.cancelLabel = "Cancel",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.themeData,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppButton(
              onPressed: () async {
                FeedbackService.clearErrorNotification();
                onAction();
              },
              isTextButton: true,
              child:  Text(actionLabel),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppButton(
              onPressed: () async {
                FeedbackService.clearErrorNotification();
                onCancel();
              },
              isTextButton: true,
              child:  Text(cancelLabel),
            ),
          ),
        ],
      ),
    );
  }
}