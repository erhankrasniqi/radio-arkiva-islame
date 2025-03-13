import 'package:flutter/material.dart';
import 'package:radio_arkiva_islame/constants/constants.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';
import 'package:radio_arkiva_islame/widgets/radio/play_button.dart';
import 'package:radio_arkiva_islame/widgets/radio/now_playing_text.dart';
import 'package:radio_arkiva_islame/widgets/radio/volume_slider.dart';

class RadioPlayerWidget extends StatelessWidget {
  const RadioPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      color: Theme.of(context).colorScheme.surfaceContainer,
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.0,
          children: [
            Image.asset(Assets.logo, fit: BoxFit.fitWidth),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  Strings.appTitle,
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
