import 'package:flutter/material.dart';
import 'package:radio_arkiva_islame/widgets/play_button.dart';
import 'package:radio_arkiva_islame/widgets/now_playing_text.dart';
import 'package:radio_arkiva_islame/widgets/volume_slider.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  _RadioScreenState createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Keeps this widget alive when off-screen

  @override
  Widget build(BuildContext context) {
    super.build(
      context,
    ); // Important: call super.build when using AutomaticKeepAliveClientMixin
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(child: const RadioPlayerWidget()),
    );
  }
}

class RadioPlayerWidget extends StatelessWidget {
  const RadioPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8.0, // Preserved your spacing parameter
          children: [
            Image.asset('assets/logo.png', fit: BoxFit.fitWidth),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4, // Preserved your spacing parameter
              children: [
                Text(
                  "Radio Arkiva Islame ",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const NowPlayingText(),
              ],
            ),
            Column(
              spacing: 12.0, // Preserved your spacing parameter
              children: const [VolumeSliderWidget(), PlayButtonWidget()],
            ),
          ],
        ),
      ),
    );
  }
}
