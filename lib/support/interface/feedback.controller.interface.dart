import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class IFeedbackController {
  RxBool spinnerDefineState({required Key key, required bool isOn});

  RxBool listenToSpinner({required Key key});

  RxBool spinnerUpdateState({required Key key, required bool isOn});
}
