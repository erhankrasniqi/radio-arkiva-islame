import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:radio_arkiva_islame/constants/constants.dart';
import 'package:radio_arkiva_islame/constants/strings.dart';
import 'package:radio_arkiva_islame/utils/debug_utils.dart';

class YoutubeService {
  static const String yt = Youtube.yt;
  static const String channelId = Youtube.channelId;
  static const String cacheBox = Strings.cacheBox;

  Future<List<Map<String, String>>> fetchLatestVideos() async {
    var box = await Hive.openBox(cacheBox);
    final now = DateTime.now();
    final String? lastFetchDateStr = box.get(Strings.lastFetchDate);

    if (lastFetchDateStr != null) {
      final lastFetchDate = DateFormat(
        'yyyy-MM-dd HH:mm',
      ).parse(lastFetchDateStr);
      final difference = now.difference(lastFetchDate).inMinutes;

      if (difference < 1440) {
        // 1 - 1 minute, 1440 daily
        final List<dynamic>? cachedData = box.get(Strings.cachedVideos);
        if (cachedData != null) {
          logDebug(
            "[CACHE] Returning cached videos (Last fetch: $lastFetchDateStr)",
          );
          return cachedData
              .map<Map<String, String>>((e) => Map<String, String>.from(e))
              .toList();
        }
      }
    }

    final newVideos = await _fetchVideosFromApi();
    if (newVideos.isNotEmpty) {
      await box.put(Strings.cachedVideos, newVideos);
      await box.put(
        Strings.lastFetchDate,
        DateFormat('yyyy-MM-dd HH:mm').format(now),
      );
    }
    logDebug("[DEBUG] Fetching videos at ${DateTime.now()}");
    logDebug("$newVideos");
    return newVideos;
  }

  Future<List<Map<String, String>>> _fetchVideosFromApi() async {
    final String searchUrl =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&maxResults=10&order=date&type=video&key=$yt';

    try {
      final searchResponse = await http.get(Uri.parse(searchUrl));
      if (searchResponse.statusCode == 200) {
        final searchData = jsonDecode(searchResponse.body);
        final videos = searchData['items'] as List;

        List<String> videoIds = [];
        Map<String, Map<String, String>> videoInfo = {};

        for (var video in videos) {
          String videoId = video['id']['videoId'];
          String title = video['snippet']['title'];
          String thumbnailUrl = video['snippet']['thumbnails']['medium']['url'];
          String publishDate = formatDate(video['snippet']['publishedAt']);

          videoIds.add(videoId);
          videoInfo[videoId] = {
            'videoId': videoId,
            'title': title,
            'thumbnailUrl': thumbnailUrl,
            'publishDate': publishDate,
          };
        }

        return await fetchVideoDetails(videoIds, videoInfo);
      } else {
        logDebug('Error fetching videos: ${searchResponse.statusCode}');
        return [];
      }
    } catch (e) {
      logDebug('Exception: $e');
      return [];
    }
  }

  Future<List<Map<String, String>>> fetchVideoDetails(
    List<String> videoIds,
    Map<String, Map<String, String>> videoInfo,
  ) async {
    if (videoIds.isEmpty) return [];

    final String detailsUrl =
        'https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id=${videoIds.join(",")}&key=$yt';

    try {
      final detailsResponse = await http.get(Uri.parse(detailsUrl));
      if (detailsResponse.statusCode == 200) {
        final detailsData = jsonDecode(detailsResponse.body);
        List<Map<String, String>> formattedVideos = [];

        for (var video in detailsData['items']) {
          String videoId = video['id'];
          String duration;
          if (video['contentDetails'].containsKey('duration') &&
              video['contentDetails']['duration'] != null) {
            duration = formatDuration(video['contentDetails']['duration']);
          } else {
            duration = 'Premiere';
          }

          formattedVideos.add({
            'videoId': videoId,
            'title': videoInfo[videoId]?['title'] ?? '',
            'thumbnailUrl': videoInfo[videoId]?['thumbnailUrl'] ?? '',
            'publishDate': videoInfo[videoId]?['publishDate'] ?? '',
            'duration': duration,
          });
        }
        return formattedVideos;
      } else {
        logDebug('Error fetching video details: ${detailsResponse.statusCode}');
        return [];
      }
    } catch (e) {
      logDebug('Exception: $e');
      return [];
    }
  }

  String formatDuration(String isoDuration) {
    final regex = RegExp(r'PT(\d+H)?(\d+M)?(\d+S)?');
    final match = regex.firstMatch(isoDuration);
    int hours = 0, minutes = 0, seconds = 0;

    if (match != null) {
      if (match.group(1) != null) {
        hours = int.parse(match.group(1)!.replaceAll('H', ''));
      }
      if (match.group(2) != null) {
        minutes = int.parse(match.group(2)!.replaceAll('M', ''));
      }
      if (match.group(3) != null) {
        seconds = int.parse(match.group(3)!.replaceAll('S', ''));
      }
    }

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
  }

  String formatDate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }
}
