import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_service/audio_service.dart';
import 'package:radio_arkiva_islame/services/radio_service.dart';
import 'package:radio_arkiva_islame/providers/media_controller_provider.dart';

class PlayButtonWidget extends StatelessWidget {
  const PlayButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final radioService = RadioService();
    final mediaController = Provider.of<MediaControllerProvider>(context, listen: false);
    return SizedBox(
      width: double.infinity,
      child: StreamBuilder<PlaybackState>(
        stream: radioService.audio.playbackState,
        builder: (context, snapshot) {
          final state = snapshot.data;
          Widget child;
          if (state == null ||
              state.processingState == AudioProcessingState.loading ||
              state.processingState == AudioProcessingState.buffering) {
            child = SizedBox(
              key: const ValueKey('loading'),
              width: 32.0,
              height: 32.0,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
                strokeWidth: 3,
              ),
            );
          } else if (state.playing) {
            child = Icon(Icons.pause, key: const ValueKey('pause'), size: 32.0);
          } else {
            child = Icon(
              Icons.play_arrow,
              key: const ValueKey('play'),
              size: 32.0,
            );
          }
          return IconButton.filled(
            onPressed: () {
              if (state != null && state.playing) {
                radioService.pause();
              } else {
                mediaController.setActiveSource(MediaSource.radio);
                radioService.play();
              }
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder:
                  (widget, animation) =>
                      ScaleTransition(scale: animation, child: widget),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
