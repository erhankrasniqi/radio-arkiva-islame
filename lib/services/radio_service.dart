import 'package:audio_service/audio_service.dart';
import 'package:radio_arkiva_islame/services/audio_handler.dart';

class RadioService {
  static final RadioService _instance = RadioService._internal();
  factory RadioService() => _instance;
  RadioService._internal();

  AudioHandler get audio => audioHandler;

  Future<void> play() async {
    await audio.play();
  }

  Future<void> pause() async {
    await audio.pause();
  }
}
