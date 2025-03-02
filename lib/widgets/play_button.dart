import 'package:flutter/material.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:radio_arkiva_islame/services/radio_service.dart';

enum PlayerState { idle, loading, playing, stopped }

class PlayButtonWidget extends StatefulWidget {
  const PlayButtonWidget({super.key});

  @override
  PlayButtonWidgetState createState() => PlayButtonWidgetState();
}

class PlayButtonWidgetState extends State<PlayButtonWidget> {
  late RadioService radioService;
  PlayerState playerState = PlayerState.idle;
  StreamSubscription? _playerStateSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    radioService = Provider.of<RadioService>(context, listen: false);

    // Listen to the player state stream
    _playerStateSubscription
        ?.cancel(); // Cancel any existing subscription to avoid leaks
    _playerStateSubscription = radioService.player.playerStateStream.listen((
      state,
    ) {
      if (!mounted) return;
      setState(() {
        if (state.processingState == ProcessingState.loading ||
            state.processingState == ProcessingState.buffering) {
          playerState = PlayerState.loading;
        } else if (state.playing) {
          playerState = PlayerState.playing;
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
                  ? const SizedBox(
                    key: ValueKey("loading"),
                    width: 32.0,
                    height: 32.0,
                    child: CircularProgressIndicator(strokeWidth: 3),
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
