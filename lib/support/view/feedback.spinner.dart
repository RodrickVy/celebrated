import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';


/// part of a feedback system that uses  a bool state and this spinner widget , to show an action in progress.
/// 1. The key given this widget  is registered by this view if not already registered.
/// 2. This view  with the key is wrapped around the widget doing the work ,
/// 3. When action is called , you use [FeedbackService] spinnerUpdateState() to set the spinner to load
/// 4. When action is complete you set the state to false, meaning the spinner should stop
/// 5. using the key of the widget you can access the loading anywhere the app
/// 
/// Serves as a great means of feedback even on small components as buttons,
/// there is also a spinner widget app wide, that any part of the app can spin
/// to show something loading , understanding that the user cant do anything until the spinner is done.
/// 
/// Issues:
///  - setMake() need s build ... : solution: makes sure you update state in the postFrameCallBack()
class FeedbackSpinner extends StatelessWidget {
  final Widget child;
  final bool defaultState;
  final Key spinnerKey;
  final Function()? onSpinEnd;
  final Function()? onSpinStart;

  FeedbackSpinner(
      {required this.child,
      this.defaultState = false,
      required this.spinnerKey,
      this.onSpinEnd,
      this.onSpinStart})
      : super(key: spinnerKey) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Loading spinner ${spinnerKey}");
      FeedbackService.spinnerDefineState(
          key: spinnerKey, isOn: defaultState);
      FeedbackService.listenToSpinner(key: spinnerKey).listen((p0) {
        if (p0 == false) {
          onSpinEnd != null ? onSpinEnd!() : () {};
        } else {
          onSpinStart != null ? onSpinStart!() : () {};
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final spinner = FeedbackService.listenToSpinner(key: spinnerKey);
    return Obx(
      () => Stack(
        children: [
          child,
          if (spinner.value == true)
            Positioned.fill(
              child: Container(
                width: Get.width,
                height: Get.height,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20.0),
                child: SpinKitFadingCircle(
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: index.isEven
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    );
                  },
                ),
              ),
            )

        ],
      ),
    );
  }
}
