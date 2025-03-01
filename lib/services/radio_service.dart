import 'dart:async';
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RadioService {
  static final RadioService _instance = RadioService._internal();
  factory RadioService() => _instance;

  RadioService._internal() {
    _fetchCurrentTitle();
    _startTitleUpdateTimer();
  }

  final AudioPlayer player = AudioPlayer();
  final StreamController<String> _titleStreamController =
      StreamController<String>.broadcast();
  String _lastFetchedTitle = '';

  final ValueNotifier<String> currentTitleNotifier = ValueNotifier(
    "Loading...",
  );

  Stream<String> get titleStream => _titleStreamController.stream;

  final String streamUrl =
      Platform.environment['STREAM'] ??
      dotenv.env['STREAM'] ??
      'http://default-stream-url';
  final String currentTitleUrl =
      Platform.environment['CURRENT_TITLE'] ??
      dotenv.env['CURRENT_TITLE'] ??
      'http://default-title-url';

  void _startTitleUpdateTimer() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchCurrentTitle();
    });
  }

  Future<void> play() async {
    try {
      if (player.playing) return;

      final localArtUri = await getLocalArtUri();

      final initialMediaItem = MediaItem(
        id: '1',
        album: "Radio Arkiva Islame",
        title: currentTitleNotifier.value,
        artUri: localArtUri,
      );

      final audioSource = AudioSource.uri(
        Uri.parse(streamUrl), // ✅ Use dynamic stream URL
        tag: initialMediaItem,
      );

      await player.setAudioSource(audioSource);
      await player.play();

      currentTitleNotifier.addListener(() async {
        final updatedMediaItem = MediaItem(
          id: '1',
          album: "Radio Arkiva Islame",
          title: currentTitleNotifier.value,
          artUri: localArtUri,
        );

        await player.setAudioSource(
          audioSource,
          initialPosition: player.position,
        );
        await player.setLoopMode(LoopMode.one);

        BaseAudioHandler().updateMediaItem(updatedMediaItem);
      });
    } catch (e) {
      print("Error playing stream: $e");
    }
  }

  Future<void> stop() async {
    await player.pause();
  }

  Future<void> _fetchCurrentTitle() async {
    try {
      final response = await http.get(
        Uri.parse(currentTitleUrl),
      ); // ✅ Use dynamic title URL

      if (response.statusCode == 200) {
        String newTitle = response.body.trim();

        if (newTitle.isNotEmpty && newTitle != _lastFetchedTitle) {
          _lastFetchedTitle = newTitle;
          _titleStreamController.add(newTitle);

          // ✅ Clean the title
          String formattedTitle =
              newTitle
                  .replaceAll(
                    RegExp(r'\s*\[.*?\]$'),
                    '',
                  ) // Remove [xyz] at the end
                  .replaceAll(
                    RegExp(r'^\s*unknown\s*-?\s*', caseSensitive: false),
                    '',
                  ) // Remove "Unknown" + dash
                  .trim();

          if (formattedTitle.isEmpty) {
            formattedTitle = "Unknown Title";
          }

          // ✅ Update ValueNotifier
          currentTitleNotifier.value = formattedTitle;
        }
      }
    } catch (e) {
      print("Error fetching Title: $e");
    }
  }

  void dispose() {
    _titleStreamController.close();
    currentTitleNotifier.dispose();
  }

  Future<Uri> getLocalArtUri() async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/logo.png');

    if (!file.existsSync()) {
      final byteData = await rootBundle.load('assets/logo.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());
    }

    return Uri.file(file.path);
  }
}
