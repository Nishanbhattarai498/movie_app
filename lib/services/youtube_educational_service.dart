import 'dart:convert';
import 'package:http/http.dart' as http;

// Educational YouTube integration (legal way to access video content)
class YouTubeEducationalService {
  // Get your free API key from Google Cloud Console
  static const String _apiKey = 'YOUR_YOUTUBE_API_KEY';
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';

  // Educational: Search for movie trailers (completely legal)
  static Future<List<YouTubeVideo>> searchTrailers(String movieTitle) async {
    final query = '$movieTitle official trailer';
    final url =
        '$_baseUrl/search?part=snippet&q=$query&type=video&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];

        return items
            .map((item) => YouTubeVideo(
                  id: item['id']['videoId'],
                  title: item['snippet']['title'],
                  description: item['snippet']['description'],
                  thumbnail: item['snippet']['thumbnails']['medium']['url'],
                  channelTitle: item['snippet']['channelTitle'],
                ))
            .toList();
      }
    } catch (e) {
      print('Error searching YouTube: $e');
    }
    return [];
  }

  // Educational: Get educational videos about filmmaking
  static Future<List<YouTubeVideo>> getFilmmakingEducation() async {
    final queries = [
      'how movies are made',
      'film production process',
      'cinematography basics',
      'film editing tutorial',
    ];

    List<YouTubeVideo> allVideos = [];
    for (final query in queries) {
      final videos = await _searchEducational(query);
      allVideos.addAll(videos);
    }
    return allVideos;
  }

  static Future<List<YouTubeVideo>> _searchEducational(String query) async {
    final url =
        '$_baseUrl/search?part=snippet&q=$query&type=video&key=$_apiKey&maxResults=5';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];

        return items
            .map((item) => YouTubeVideo(
                  id: item['id']['videoId'],
                  title: item['snippet']['title'],
                  description: item['snippet']['description'],
                  thumbnail: item['snippet']['thumbnails']['medium']['url'],
                  channelTitle: item['snippet']['channelTitle'],
                ))
            .toList();
      }
    } catch (e) {
      print('Error searching educational content: $e');
    }
    return [];
  }
}

class YouTubeVideo {
  final String id;
  final String title;
  final String description;
  final String thumbnail;
  final String channelTitle;

  YouTubeVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.channelTitle,
  });

  // Educational: How to construct legal YouTube URLs
  String get watchUrl => 'https://www.youtube.com/watch?v=$id';
  String get embedUrl => 'https://www.youtube.com/embed/$id';
}
