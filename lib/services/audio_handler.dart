import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:radio_arkiva_islame/constants/constants.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';
import 'package:radio_arkiva_islame/utils/debug_utils.dart';

late AudioHandler audioHandler;

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  static final _baseMediaItem = MediaItem(
    id: RadioStream.stream,
    album: Strings.appTitle,
    title: Strings.loading,
    artUri: Uri.parse(Assets.artUri),
  );

  final _player = AudioPlayer();
  String _lastFetchedTitle = _baseMediaItem.title;
  bool _hasInternet = false;
  bool _audioSourceInitialized = false;

  AudioPlayerHandler() {
    _init();
  }

  Future<void> _init() async {
    logDebug("DEBUG: Initializing AudioPlayerHandler.");
    _hasInternet = await _checkInternet();
    logDebug("DEBUG: Initial internet status: $_hasInternet");
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    mediaItem.add(_baseMediaItem);

    if (_hasInternet) {
      await _initializeAudioSource();
      await _fetchCurrentTitle();
    } else {
      logDebug("DEBUG: No internet at initialization. Audio source not set.");
    }

    Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchCurrentTitle();
    });

    Connectivity().onConnectivityChanged.listen((result) async {
      bool internetNow = await _checkInternet();
      logDebug(
        "DEBUG: Connectivity changed. New internet status: $internetNow",
      );
      if (!internetNow && _hasInternet) {
        _hasInternet = false;
        logDebug(
          "DEBUG: Internet lost. Pausing playback and resetting audio source.",
        );
        await pause();
      } else if (internetNow && !_hasInternet) {
        _hasInternet = true;
        logDebug("DEBUG: Internet restored. Auto-playing stream.");
        await play();
      }
    });
  }

  Future<void> _initializeAudioSource() async {
    try {
      logDebug("DEBUG: Setting audio source.");
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(_baseMediaItem.id)),
      );
      _audioSourceInitialized = true;
      logDebug("DEBUG: Audio source initialized successfully.");
    } catch (e) {
      logDebug("DEBUG: Error setting audio source: $e");
    }
  }

  @override
  Future<void> play() async {
    if (!_hasInternet) {
      logDebug("DEBUG: No internet. Cannot play.");
      return;
    }
    if (!_audioSourceInitialized) {
      logDebug("DEBUG: Audio source not initialized. Initializing now.");
      await _initializeAudioSource();
    }
    try {
      // Manual reset before playing if stuck in a loading/buffering state.
      if (_player.processingState == ProcessingState.loading ||
          _player.processingState == ProcessingState.buffering) {
        logDebug(
          "DEBUG: Player in loading/buffering state. Resetting playback position to 0.",
        );
        await _player.seek(Duration.zero);
      }
      logDebug("DEBUG: Attempting to play audio.");
      await _player.play();
      // Ensure title fetch continues
      _fetchCurrentTitle();
      logDebug("DEBUG: Audio play triggered.");
    } catch (e) {
      logDebug("DEBUG: Error playing audio: $e");
    }
  }

  @override
  Future<void> pause() async {
    try {
      logDebug("DEBUG: Pausing audio playback.");
      await _player.pause();
    } catch (e) {
      logDebug("DEBUG: Error pausing audio: $e");
    }
  }

  @override
  Future<void> stop() async {
    try {
      logDebug("DEBUG: Stopping audio playback.");
      await _player.stop();
    } catch (e) {
      logDebug("DEBUG: Error stopping audio: $e");
    }
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1],
      processingState:
          const {
            ProcessingState.idle: AudioProcessingState.idle,
            ProcessingState.loading: AudioProcessingState.loading,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }

  Future<void> _fetchCurrentTitle() async {
    if (!_hasInternet) {
      logDebug("DEBUG: No internet. Skipping title fetch.");
      return;
    }
    try {
      final response = await http
          .get(Uri.parse(RadioStream.currentTitle))
          .timeout(const Duration(seconds: 1));
      if (response.statusCode == 200) {
        String newTitle = response.body.trim();
        if (newTitle.isEmpty) newTitle = Strings.unknownTitle;
        if (newTitle != _lastFetchedTitle) {
          _lastFetchedTitle = newTitle;
          String formattedTitle =
              newTitle
                  .replaceAll(RegExp(r'\s*\[.*?\]$'), '')
                  .replaceAll(
                    RegExp(r'^\s*unknown\s*-?\s*', caseSensitive: false),
                    '',
                  )
                  .trim();
          if (formattedTitle.isEmpty) formattedTitle = Strings.unknownTitle;
          mediaItem.add(mediaItem.value!.copyWith(title: formattedTitle));
          logDebug("DEBUG: Updated title: $formattedTitle");
        }
      } else {
        logDebug(
          "DEBUG: Title fetch failed with status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      logDebug("DEBUG: Error fetching title: $e");
    }
  }

  Future<bool> _checkInternet() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    bool hasInternet =
        connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet);
    logDebug("DEBUG: _checkInternet result: $hasInternet");
    return hasInternet;
  }
}
