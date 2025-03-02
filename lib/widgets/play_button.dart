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

  bool _isAttemptingPlay = false;

  @override
  void initState() {
    super.initState();
    _playerStateSubscription = radioService.player.playerStateStream.listen((
      state,
    ) {
      if (!mounted) return;
      setState(() {
        if (state.processingState == ProcessingState.loading ||
            state.processingState == ProcessingState.buffering) {
          playerState = PlayerState.loading;
        } else if (state.processingState == ProcessingState.ready) {
          if (state.playing) {
            _isAttemptingPlay = false;
            playerState = PlayerState.playing;
          } else {
            playerState =
                _isAttemptingPlay ? PlayerState.loading : PlayerState.stopped;
          }
        } else if (state.processingState == ProcessingState.completed) {
          playerState = PlayerState.stopped;
        } else {
          playerState = PlayerState.stopped;
        }
      });
    });
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
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
            setState(() {
              _isAttemptingPlay = true;
              playerState = PlayerState.loading;
            });
            await radioService.play();
          }
        },
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
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
