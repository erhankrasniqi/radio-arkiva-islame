import 'package:flutter/widgets.dart';

class FabLoader {
  static final ValueNotifier<bool> isLoading = ValueNotifier(false);
  static bool _waitingForResume = false;

  static void startLoading() {
    isLoading.value = true;
    _waitingForResume = true;
  }

  static void stopLoading() {
    isLoading.value = false;
    _waitingForResume = false;
  }

  static void handleAppResume() {
    if (_waitingForResume) {
      stopLoading();
    }
  }
}
