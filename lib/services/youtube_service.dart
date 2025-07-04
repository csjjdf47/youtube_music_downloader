import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import '../models/video.dart' as models;

class YouTubeService {
  final YoutubeExplode _yt = YoutubeExplode();

  Future<List<models.Video>> searchVideos(String query) async {
    try {
      final searchResults = await _yt.search.search(query);
      
      List<models.Video> videos = [];
      
      for (var result in searchResults.take(20)) {
        if (result is SearchVideo) {
          videos.add(models.Video(
            id: result.id.value,
            title: result.title,
            author: result.author,
            thumbnailUrl: result.thumbnails.highResUrl,
            duration: result.duration ?? Duration.zero,
            url: result.url,
          ));
        }
      }
      
      return videos;
    } catch (e) {
      print('Error searching videos: $e');
      return [];
    }
  }

  Future<StreamManifest?> getAudioStreams(String videoId) async {
    try {
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);
      return manifest;
    } catch (e) {
      print('Error getting audio streams: $e');
      return null;
    }
  }

  Future<String?> getVideoTitle(String videoId) async {
    try {
      final video = await _yt.videos.get(videoId);
      return video.title;
    } catch (e) {
      print('Error getting video title: $e');
      return null;
    }
  }

  void dispose() {
    _yt.close();
  }
}
