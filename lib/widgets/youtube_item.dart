import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:radio_arkiva_islame/constants/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class YoutubeItem extends StatelessWidget {
  final String videoId;
  final String title;
  final String thumbnailUrl;
  final String duration;
  final String publishDate;

  const YoutubeItem({
    super.key,
    required this.videoId,
    required this.title,
    required this.thumbnailUrl,
    required this.duration,
    required this.publishDate,
  });

  void _launchVideo() async {
    final youtubeUrl = "https://www.youtube.com/watch?v=$videoId";
    final youtubeAppUrl = "vnd.youtube:$videoId";

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
    return InkWell(
      onTap: _launchVideo,
      splashColor: Theme.of(
        context,
      ).colorScheme.primary.withValues(alpha: (0.3 * 255)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12.0,
          children: [
            Flexible(
              flex: 55,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: thumbnailUrl,
                    placeholder:
                        (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                    errorWidget:
                        (context, url, error) =>
                            Image.asset(Assets.placeholder, fit: BoxFit.cover),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Flexible(child: DurationAndDateText(text: duration)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: DurationAndDateText(text: '·'),
                      ),
                      Flexible(child: DurationAndDateText(text: publishDate)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DurationAndDateText extends StatelessWidget {
  final String text;
  const DurationAndDateText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.labelMedium!.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
