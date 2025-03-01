import 'package:flutter/material.dart';
import '../services/youtube_service.dart';

class YoutubeProvider extends ChangeNotifier {
  final YoutubeService _youtubeService = YoutubeService();
  List<Map<String, String>> _videos = [];
  bool _isLoading = true;

  List<Map<String, String>> get videos => _videos;
  bool get isLoading => _isLoading;

  Future<void> fetchVideos() async {
    _isLoading = true;
    notifyListeners();

    _videos = await _youtubeService.fetchLatestVideos();

    _isLoading = false;
    notifyListeners();
  }
}
