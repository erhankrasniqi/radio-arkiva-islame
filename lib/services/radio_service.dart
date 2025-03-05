import 'dart:async';
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:audio_service/audio_service.dart';
import 'package:radio_arkiva_islame/constants/constants.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
    Strings.loading,
  );

  MediaItem? _mediaItem;
  AudioSource? _audioSource;

  Stream<String> get titleStream => _titleStreamController.stream;

  Future<void> _initializeMedia() async {
    final localArtUri = await getLocalArtUri();
    _mediaItem = MediaItem(
      id: '1',
      album: Strings.appTitle,
      title: currentTitleNotifier.value,
      artUri: localArtUri,
    );
    _audioSource = AudioSource.uri(
      Uri.parse(RadioStream.stream),
      tag: _mediaItem,
    );
    currentTitleNotifier.addListener(_updateMetadata);
  }

  void _updateMetadata() async {
    if (_mediaItem == null) return;
    final updatedMediaItem = _mediaItem!.copyWith(
      title: currentTitleNotifier.value,
    );
    _mediaItem = updatedMediaItem;
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

      if (_audioSource == null) {
        await _initializeMedia();
      }

      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.none)) {
        print("No internet connection available for playing stream.");
        await stop();
        throw Exception("No internet connection available.");
      }

      await player
          .setAudioSource(_audioSource!)
          .timeout(const Duration(seconds: 10));
      await player.play();
    } catch (e) {
      print("Error playing stream: $e");
      await stop();
      rethrow;
    }
  }

  Future<void> stop() async {
    await player.stop();
  }

  Future<void> _fetchCurrentTitle() async {
    try {
      // Check connectivity before making the network call
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.none)) {
        print("No internet connection available for fetching title.");
        return;
      }

      final response = await http
          .get(Uri.parse(RadioStream.currentTitle))
          .timeout(const Duration(seconds: 1));

      if (response.statusCode == 200) {
        String newTitle = response.body.trim();

        if (newTitle.isEmpty) {
          if (_lastFetchedTitle != Strings.unknownTitle) {
            _lastFetchedTitle = Strings.unknownTitle;
            currentTitleNotifier.value = Strings.unknownTitle;
            _titleStreamController.add(Strings.unknownTitle);
          }
          return;
        }

        if (newTitle != _lastFetchedTitle) {
          _lastFetchedTitle = newTitle;
          _titleStreamController.add(newTitle);

          String formattedTitle =
              newTitle
                  .replaceAll(RegExp(r'\s*\[.*?\]$'), '')
                  .replaceAll(
                    RegExp(r'^\s*unknown\s*-?\s*', caseSensitive: false),
                    '',
                  )
                  .trim();

          if (formattedTitle.isEmpty) {
            formattedTitle = Strings.unknownTitle;
          }

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
