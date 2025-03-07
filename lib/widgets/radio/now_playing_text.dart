import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:radio_arkiva_islame/services/radio_service.dart';

class NowPlayingText extends StatelessWidget {
  const NowPlayingText({super.key});

  @override
  Widget build(BuildContext context) {
    final RadioService radioService = RadioService();
    return StreamBuilder<MediaItem?>(
      stream: radioService.audio.mediaItem,
      builder: (context, snapshot) {
        final mediaItem = snapshot.data;
        return Text(
          mediaItem?.title ?? '',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          softWrap: true,
          maxLines: null,
        );
      },
    );
  }
}
