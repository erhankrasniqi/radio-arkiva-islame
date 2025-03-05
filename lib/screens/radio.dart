import 'package:flutter/material.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';
import 'package:radio_arkiva_islame/widgets/ads_carousel.dart';
import 'package:radio_arkiva_islame/widgets/radio/radio_player.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  RadioScreenState createState() => RadioScreenState();
}

class RadioScreenState extends State<RadioScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RadioPlayerWidget(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2.0,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  Strings.marketing,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: AdsCarousel(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
