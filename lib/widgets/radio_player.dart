import 'package:flutter/material.dart';
import 'package:radio_arkiva_islame/widgets/play_button.dart';
import 'package:radio_arkiva_islame/widgets/now_playing_text.dart';
import 'package:radio_arkiva_islame/widgets/volume_slider.dart';

class RadioPlayerWidget extends StatelessWidget {
  const RadioPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.surface,
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.0,
          children: [
            Image.asset('assets/logo.png', fit: BoxFit.fitWidth),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  "Radio Arkiva Islame",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const NowPlayingText(),
              ],
            ),
            Column(
              spacing: 12.0,
              children: const [VolumeSliderWidget(), PlayButtonWidget()],
            ),
          ],
        ),
      ),
    );
  }
}
