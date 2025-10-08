import 'package:flutter/widgets.dart';
import 'fab_loader.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  AppLifecycleObserver._privateConstructor();

  static final AppLifecycleObserver instance =
      AppLifecycleObserver._privateConstructor();

  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      FabLoader.handleAppResume();
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
