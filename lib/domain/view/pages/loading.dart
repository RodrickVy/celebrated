import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinner extends StatelessWidget {
  final String message;

  const LoadingSpinner({
    Key? key,
    this.message = "getting things ready...",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinKitSpinningCircle(
          color: Adaptive(context).theme.colorScheme.primary,
        ),
        Text(message)
      ],
    );
  }
}
