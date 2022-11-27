import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinKitSpinningCircle(
          color: Adaptive(context).theme.colorScheme.primary,
        ),
        const Text("getting things ready...")
      ],
    );
  }
}