import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class SpinnerView extends StatelessWidget {
  final Widget child;
  final bool defaultState;
  final Key spinnerKey;
  final Function()? onSpinEnd;
  final Function()? onSpinStart;

  SpinnerView(
      {Key? key, required this.child,
      this.defaultState = false,
      required this.spinnerKey,
      this.onSpinEnd,
      this.onSpinStart})
      : super(key: key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FeedbackController.spinnerDefineState(
          key: spinnerKey, isOn: defaultState);
      FeedbackController.listenToSpinner(key: spinnerKey).listen((p0) {
        if (p0 == false) {
          onSpinEnd != null ? onSpinEnd!() : () {};
        } else {
          onSpinStart != null ? onSpinStart!() : () {};
        }
        Get.log("loading $defaultState");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final spinner = FeedbackController.listenToSpinner(key: spinnerKey);
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
