import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Uses generic types to give you easy access to the controller when building, as well as the handy [Adaptive] features for adaptive widgets.
abstract class AppStateView<T> extends StatelessWidget {
  final T controller = Get.find<T>();

  AppStateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return view(ctx: context, adapter: Adaptive(context));
  }

  Widget view({required BuildContext ctx, required Adaptive adapter});
}
