import 'dart:async';
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:audio_service/audio_service.dart';

class RadioService {
  static final RadioService _instance = RadioService._internal();
  factory RadioService() => _instance;
  RadioService._internal() {
    // Start fetching title updates on creation.
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

  // Persistent media item and audio source.
  MediaItem? _mediaItem;
  AudioSource? _audioSource;

  Stream<String> get titleStream => _titleStreamController.stream;

  /// Initializes the media item and audio source.
  Future<void> _initializeMedia() async {
    final localArtUri = await getLocalArtUri();
    _mediaItem = MediaItem(
      id: '1',
      album: "Radio Arkiva Islame",
      title: currentTitleNotifier.value,
      artUri: localArtUri,
    );
    _audioSource = AudioSource.uri(
      Uri.parse('http://65.108.198.245:9638/stream'),
      tag: _mediaItem,
    );

    // Register the metadata update listener only once.
    currentTitleNotifier.addListener(_updateMetadata);
  }

  /// Updates the media item metadata when the title changes.
  void _updateMetadata() async {
    if (_mediaItem == null) return;
    final updatedMediaItem = _mediaItem!.copyWith(
      title: currentTitleNotifier.value,
    );
    _mediaItem = updatedMediaItem;
    // Update the audio service metadata.
    BaseAudioHandler().updateMediaItem(updatedMediaItem);
  }

  void _startTitleUpdateTimer() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchCurrentTitle();
    });
  }

  Future<void> play() async {
    try {
      if (player.playing) return;

      // Initialize media only once.
      if (_audioSource == null) {
        await _initializeMedia();
      }

      await player.setAudioSource(_audioSource!);
      await player.play();

      // Optionally set loop mode.
      await player.setLoopMode(LoopMode.one);
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
        Uri.parse("http://65.108.198.245:9638/currentsong"),
      );

      if (response.statusCode == 200) {
        // Trim the response.
        String newTitle = response.body.trim();

        // If the fetched title is empty, use a default placeholder.
        if (newTitle.isEmpty) {
          if (_lastFetchedTitle != "Unknown Title") {
            _lastFetchedTitle = "Unknown Title";
            currentTitleNotifier.value = "Unknown Title";
            _titleStreamController.add("Unknown Title");
          }
          return;
        }

        // Only update if the title has changed.
        if (newTitle != _lastFetchedTitle) {
          _lastFetchedTitle = newTitle;
          _titleStreamController.add(newTitle);

          // Clean the title.
          String formattedTitle =
              newTitle
                  .replaceAll(RegExp(r'\s*\[.*?\]$'), '')
                  .replaceAll(
                    RegExp(r'^\s*unknown\s*-?\s*', caseSensitive: false),
                    '',
                  )
                  .trim();

          if (formattedTitle.isEmpty) {
            formattedTitle = "Unknown Title";
          }

          // Update the ValueNotifier which in turn updates metadata.
          currentTitleNotifier.value = formattedTitle;
        }
      }
    } catch (e) {
      print("Error fetching title: $e");
    }
  }

  void dispose() {
    _titleStreamController.close();
    currentTitleNotifier.dispose();
    player.dispose();
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
