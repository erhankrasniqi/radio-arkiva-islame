import 'package:flutter/foundation.dart';

enum MediaSource {
  radio,
  tv,
  none,
}

class MediaControllerProvider extends ChangeNotifier {
  MediaSource _activeSource = MediaSource.none;

  MediaSource get activeSource => _activeSource;

  void setActiveSource(MediaSource source) {
    if (_activeSource != source) {
      _activeSource = source;
      notifyListeners();
    }
  }

  void clearActiveSource() {
    _activeSource = MediaSource.none;
    notifyListeners();
  }
}
