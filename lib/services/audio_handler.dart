import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:radio_arkiva_islame/constants/constants.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';

late AudioHandler audioHandler;

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  static final _baseMediaItem = MediaItem(
    id: RadioStream.stream,
    album: Strings.appTitle,
    title: Strings.loading,
    artUri: Uri.parse(
      'https://arkivaislame.com/wp-content/uploads/2024/03/logo-hd.png',
    ),
  );

  final _player = AudioPlayer();
  String _lastFetchedTitle = _baseMediaItem.title;
  Timer? _titleFetchTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _hasInternet = false;
  bool _audioSourceInitialized = false;

  AudioPlayerHandler() {
    _init();
  }

  Future<void> _init() async {
    print("DEBUG: Initializing AudioPlayerHandler.");
    _hasInternet = await _checkInternet();
    print("DEBUG: Initial internet status: $_hasInternet");
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    mediaItem.add(_baseMediaItem);

    if (_hasInternet) {
      await _initializeAudioSource();
      await _fetchCurrentTitle();
    } else {
      print("DEBUG: No internet at initialization. Audio source not set.");
    }

    _titleFetchTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchCurrentTitle();
    });

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) async {
      bool internetNow = await _checkInternet();
      print("DEBUG: Connectivity changed. New internet status: $internetNow");
      if (!internetNow && _hasInternet) {
        _hasInternet = false;
        // Reset the flag so the audio source is reinitialized when connection is restored.
        // _audioSourceInitialized = false;
        print(
          "DEBUG: Internet lost. Pausing playback and resetting audio source.",
        );
        await pause();
      } else if (internetNow && !_hasInternet) {
        _hasInternet = true;
        print("DEBUG: Internet restored. Auto-playing stream.");
        await play();
      }
    });
  }

  Future<void> _initializeAudioSource() async {
    try {
      print("DEBUG: Setting audio source.");
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(_baseMediaItem.id)),
      );
      _audioSourceInitialized = true;
      print("DEBUG: Audio source initialized successfully.");
    } catch (e) {
      print("DEBUG: Error setting audio source: $e");
    }
  }

  @override
  Future<void> play() async {
    if (!_hasInternet) {
      print("DEBUG: No internet. Cannot play.");
      return;
    }
    if (!_audioSourceInitialized) {
      print("DEBUG: Audio source not initialized. Initializing now.");
      await _initializeAudioSource();
    }
    try {
      // Second snippet: Manual reset before playing if stuck in a loading/buffering state.
      if (_player.processingState == ProcessingState.loading ||
          _player.processingState == ProcessingState.buffering) {
        print(
          "DEBUG: Player in loading/buffering state. Resetting playback position to 0.",
        );
        await _player.seek(Duration.zero);
      }
      print("DEBUG: Attempting to play audio.");
      await _player.play();
      _fetchCurrentTitle(); // Ensure title fetch continues
      print("DEBUG: Audio play triggered.");
    } catch (e) {
      print("DEBUG: Error playing audio: $e");
    }
  }

  @override
  Future<void> pause() async {
    try {
      print("DEBUG: Pausing audio playback.");
      await _player.pause();
    } catch (e) {
      print("DEBUG: Error pausing audio: $e");
    }
  }

  @override
  Future<void> stop() async {
    try {
      print("DEBUG: Stopping audio playback.");
      await _player.stop();
    } catch (e) {
      print("DEBUG: Error stopping audio: $e");
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
      print("DEBUG: No internet. Skipping title fetch.");
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
          // Update the media item without re-adding it.
          mediaItem.add(mediaItem.value!.copyWith(title: formattedTitle));
          print("DEBUG: Updated title: $formattedTitle");
        }
      } else {
        print(
          "DEBUG: Title fetch failed with status code: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("DEBUG: Error fetching title: $e");
    }
  }

  Future<bool> _checkInternet() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    bool hasInternet =
        connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet);
    print("DEBUG: _checkInternet result: $hasInternet");
    return hasInternet;
  }
}
