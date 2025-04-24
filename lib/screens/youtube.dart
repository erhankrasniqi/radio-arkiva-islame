import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';
import 'package:radio_arkiva_islame/providers/youtube_provider.dart';
import 'package:radio_arkiva_islame/widgets/youtube_channel.dart';
import 'package:radio_arkiva_islame/widgets/youtube_item.dart';

class YoutubeScreen extends StatelessWidget {
  const YoutubeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<YoutubeProvider>(
      builder: (context, youtubeProvider, child) {
        if (youtubeProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (youtubeProvider.videos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 4.0,
              children: [
                const Text(Strings.noVideos),
                FilledButton.tonal(
                  onPressed:
                      () => context.read<YoutubeProvider>().fetchVideos(),
                  child: const Text(Strings.tryAgain),
                ),
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChannelWidget(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(
                  top: 8.0,
                  bottom: MediaQuery.of(context).padding.bottom + 4.0,
                ),
                itemCount: youtubeProvider.videos.length,
                itemBuilder: (context, index) {
                  final video = youtubeProvider.videos[index];

                  return YoutubeItem(
                    videoId: video['videoId'] ?? '',
                    title: video['title'] ?? 'Unknown',
                    thumbnailUrl: video['thumbnailUrl'] ?? '',
                    duration: video['duration'] ?? 'N/A',
                    publishDate: video['publishDate'] ?? 'N/A',
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
