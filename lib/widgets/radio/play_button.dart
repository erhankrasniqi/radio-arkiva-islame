import 'package:flutter/material.dart';
import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';
import 'package:radio_arkiva_islame/services/radio_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum PlayerState { idle, loading, playing, stopped }

class PlayButtonWidget extends StatefulWidget {
  const PlayButtonWidget({super.key});

  @override
  PlayButtonWidgetState createState() => PlayButtonWidgetState();
}

class PlayButtonWidgetState extends State<PlayButtonWidget> {
  final RadioService radioService = RadioService();
  PlayerState playerState = PlayerState.playing;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isAttemptingPlay = false;

  @override
  void initState() {
    super.initState();
    _playerStateSubscription = radioService.player.playerStateStream.listen((
      state,
    ) {
      if (!mounted) return;
      if (state.processingState == ProcessingState.loading ||
          state.processingState == ProcessingState.buffering) {
        Connectivity().checkConnectivity().then((result) {
          if (result.contains(ConnectivityResult.none)) {
            radioService.stop();
            if (mounted) {
              setState(() {
                _isAttemptingPlay = false;
                playerState = PlayerState.stopped;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(Strings.noInternet),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          } else {
            if (mounted) {
              setState(() {
                playerState = PlayerState.loading;
              });
            }
          }
        });
      } else if (state.processingState == ProcessingState.ready) {
        if (state.playing) {
          _isAttemptingPlay = false;
          setState(() {
            playerState = PlayerState.playing;
          });
        } else {
          setState(() {
            playerState =
                _isAttemptingPlay ? PlayerState.loading : PlayerState.stopped;
          });
        }
      } else if (state.processingState == ProcessingState.completed) {
        setState(() {
          playerState = PlayerState.stopped;
        });
      } else {
        setState(() {
          playerState = PlayerState.stopped;
        });
      }
    });

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      result,
    ) {
      if (result.contains(ConnectivityResult.none)) {
        if (playerState == PlayerState.loading) {
          setState(() {
            _isAttemptingPlay = false;
            playerState = PlayerState.stopped;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _playerStateSubscription?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: IconButton.filled(
        onPressed: () async {
          if (playerState == PlayerState.loading) {
            await radioService.stop();
            setState(() {
              _isAttemptingPlay = false;
              playerState = PlayerState.stopped;
            });
            return;
          }
          if (playerState == PlayerState.playing) {
            await radioService.stop();
            setState(() {
              playerState = PlayerState.stopped;
            });
          } else {
            setState(() {
              _isAttemptingPlay = true;
              playerState = PlayerState.loading;
            });
            try {
              await radioService.play();
            } catch (e) {
              setState(() {
                _isAttemptingPlay = false;
                playerState = PlayerState.stopped;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(Strings.noInternet),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
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
