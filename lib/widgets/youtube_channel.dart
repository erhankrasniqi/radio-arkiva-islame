import 'package:flutter/material.dart';
import 'package:radio_arkiva_islame/constants/constants.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class ChannelWidget extends StatelessWidget {
  const ChannelWidget({super.key});

  void _launchChannel() async {
    const channelId = Youtube.channelId;
    final youtubeAppUrl = "vnd.youtube://channel/$channelId";
    final youtubeUrl = Youtube.ytUrl;

    if (await canLaunchUrl(Uri.parse(youtubeAppUrl))) {
      await launchUrl(Uri.parse(youtubeAppUrl));
    } else {
      await launchUrl(
        Uri.parse(youtubeUrl),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(12.0),
        bottomRight: Radius.circular(12.0),
      ),
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: InkWell(
        onTap: _launchChannel,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.0),
          bottomRight: Radius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
            left: 32.0,
            right: 32.0,
            bottom: 16.0,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundImage: AssetImage(Assets.logoSquareBg),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.arkivaIslame,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      Strings.arkivaIslameYoutube,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
