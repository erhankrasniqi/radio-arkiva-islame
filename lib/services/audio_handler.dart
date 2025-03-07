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
    _hasInternet = await _checkInternet();
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    mediaItem.add(_baseMediaItem);

    if (_hasInternet) {
      await _initializeAudioSource();
      await _fetchCurrentTitle();
    } else {
      print("No internet. Audio source not set.");
    }

    _titleFetchTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _fetchCurrentTitle();
    });

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) async {
      bool internetNow = await _checkInternet();
      if (internetNow && !_hasInternet) {
        _hasInternet = true;
        print("Internet restored.");
        // DO NOT RE-ADD MEDIA ITEM, JUST UPDATE TITLE LATER
        _fetchCurrentTitle();
      } else if (!internetNow && _hasInternet) {
        _hasInternet = false;
        print("Internet lost. Pausing playback.");
        await pause();
      }
    });
  }

  Future<void> _initializeAudioSource() async {
    try {
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(_baseMediaItem.id)),
      );
      _audioSourceInitialized = true;
      print("Audio source initialized.");
    } catch (e) {
      print("Error setting audio source: $e");
    }
  }

  @override
  Future<void> play() async {
    if (!_hasInternet) {
      print("No internet. Cannot play.");
      return;
    }
    if (!_audioSourceInitialized) {
      await _initializeAudioSource();
    }
    try {
      await _player.play();
      _fetchCurrentTitle(); // Make sure title fetch starts again
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  @override
  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      print("Error stopping audio: $e");
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
      print("No internet. Skipping title fetch.");
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
          // UPDATE MEDIA ITEM WITHOUT RE-ADDING IT
          mediaItem.add(mediaItem.value!.copyWith(title: formattedTitle));
          print("Updated title: $formattedTitle");
        }
      }
    } catch (e) {
      print("Error fetching title: $e");
    }
  }

  Future<bool> _checkInternet() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();
    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet);
  }
}
