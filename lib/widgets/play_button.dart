import 'package:flutter/material.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:radio_arkiva_islame/services/radio_service.dart';

enum PlayerState { idle, loading, playing, stopped }

class PlayButtonWidget extends StatefulWidget {
  const PlayButtonWidget({super.key});

  @override
  PlayButtonWidgetState createState() => PlayButtonWidgetState();
}

class PlayButtonWidgetState extends State<PlayButtonWidget> {
  final RadioService radioService = RadioService();
  PlayerState playerState = PlayerState.idle;
  StreamSubscription? _playerStateSubscription;

  // Flag to track if playback has started at least once.
  bool _hasStartedPlaying = false;

  @override
  void initState() {
    super.initState();
    _playerStateSubscription = radioService.player.playerStateStream.listen((
      state,
    ) {
      if (!mounted) return; // Prevent setState() on disposed widget
      setState(() {
        if (state.processingState == ProcessingState.loading ||
            state.processingState == ProcessingState.buffering) {
          // Always show spinner if loading or buffering.
          playerState = PlayerState.loading;
        } else if (state.processingState == ProcessingState.ready) {
          if (state.playing) {
            // Mark that we have started playback.
            _hasStartedPlaying = true;
            playerState = PlayerState.playing;
          } else {
            // When paused, if we haven't started playing before, keep it loading.
            // Otherwise, show the play icon.
            playerState =
                _hasStartedPlaying ? PlayerState.stopped : PlayerState.loading;
          }
        } else if (state.processingState == ProcessingState.completed) {
          // When completed, show a replay (or play) icon.
          playerState = PlayerState.stopped;
        } else {
          playerState = PlayerState.stopped;
        }
      });
    });
  }

  @override
  void dispose() {
    _playerStateSubscription
        ?.cancel(); // Cancel stream subscription to prevent errors
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: IconButton.filled(
        onPressed: () async {
          if (playerState == PlayerState.playing) {
            await radioService.stop();
          } else {
            await radioService.play();
          }
        },
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150), // Smooth transition
          transitionBuilder:
              (widget, animation) =>
                  ScaleTransition(scale: animation, child: widget),
          child:
              playerState == PlayerState.loading
                  ? SizedBox(
                    key: const ValueKey("loading"),
                    width: 32.0,
                    height: 32.0,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                      strokeWidth: 3,
                    ),
                  )
                  : Icon(
                    key: ValueKey(playerState),
                    playerState == PlayerState.playing
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 32.0,
                  ),
        ),
      ),
    );
  }
}
