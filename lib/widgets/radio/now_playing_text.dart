import 'package:flutter/material.dart';
import 'package:radio_arkiva_islame/services/radio_service.dart';

class NowPlayingText extends StatelessWidget {
  const NowPlayingText({super.key});

  @override
  Widget build(BuildContext context) {
    final RadioService radioService = RadioService();

    return ValueListenableBuilder<String>(
      valueListenable: radioService.currentTitleNotifier,
      builder: (context, currentSong, child) {
        return Text(
          currentSong,
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
