import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChannelWidget extends StatelessWidget {
  const ChannelWidget({super.key});

  void _launchChannel() async {
    const channelId = "UCJzlcANj25wt8vh7ZTDEEtg";
    final youtubeAppUrl = "vnd.youtube://channel/$channelId";
    final youtubeUrl = "https://www.youtube.com/@arkivaislame1675";

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        elevation: 2.0,
        child: InkWell(
          onTap: _launchChannel,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: AssetImage('assets/logo_square_bg.jpg'),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Arkiva Islame',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        '@arkivaislame1675',
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
      ),
    );
  }
}
