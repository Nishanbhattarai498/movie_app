import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/streaming_source.dart';

class PublicDomainService {
  // Internet Archive has many public domain movies
  static const String _baseUrl = 'https://archive.org/metadata';
  
  // Sample public domain movies from Internet Archive
  static const Map<int, String> _publicDomainMovies = {
    1: 'night_of_the_living_dead_1968', // Night of the Living Dead (1968)
    2: 'plan_9_from_outer_space', // Plan 9 from Outer Space
    3: 'the_cabinet_of_dr_caligari', // The Cabinet of Dr. Caligari
    4: 'metropolis_1927', // Metropolis (1927)
    5: 'charade_1963', // Charade (1963)
    6: 'his_girl_friday', // His Girl Friday
    7: 'the_great_dictator', // The Great Dictator
    8: 'duck_and_cover_1951', // Duck and Cover
    9: 'reefer_madness_1936', // Reefer Madness
    10: 'the_phantom_of_the_opera_1925', // Phantom of the Opera (1925)
  };
  
  static Future<List<StreamingSource>> getMovieStreams(int movieId) async {
    final archiveId = _publicDomainMovies[movieId];
    if (archiveId == null) {
      return _getFallbackStreams();
    }
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$archiveId'),
        headers: {'Accept': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parseArchiveStreams(data, archiveId);
      }
    } catch (e) {
      print('Error fetching streams: $e');
    }
    
    return _getFallbackStreams();
  }
  
  static List<StreamingSource> _parseArchiveStreams(Map<String, dynamic> data, String archiveId) {
    final List<StreamingSource> sources = [];
    
    if (data['files'] != null) {
      final files = data['files'] as Map<String, dynamic>;
      
      files.forEach((filename, fileData) {
        if (fileData['format'] == 'MPEG4' || fileData['format'] == 'h.264') {
          final size = fileData['size'] ?? '';
          String quality = 'SD';
          
          if (filename.contains('1080p') || size.contains('G')) {
            quality = '1080p';
          } else if (filename.contains('720p')) {
            quality = '720p';
          } else if (filename.contains('480p')) {
            quality = '480p';
          }
          
          sources.add(StreamingSource(
            quality: quality,
            url: 'https://archive.org/download/$archiveId/$filename',
            type: 'mp4',
          ));
        }
      });
    }
    
    // Sort by quality (highest first)
    sources.sort((a, b) {
      const qualityOrder = {'1080p': 3, '720p': 2, '480p': 1, 'SD': 0};
      return (qualityOrder[b.quality] ?? 0) - (qualityOrder[a.quality] ?? 0);
    });
    
    return sources.isNotEmpty ? sources : _getFallbackStreams();
  }
  
  static List<StreamingSource> _getFallbackStreams() {
    // Fallback to demo streams if no real content is available
    return [
      StreamingSource(
        quality: '1080p',
        url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        type: 'mp4',
      ),
      StreamingSource(
        quality: '720p',
        url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        type: 'mp4',
      ),
      StreamingSource(
        quality: '480p',
        url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        type: 'mp4',
      ),
    ];
  }
  
  static bool hasRealContent(int movieId) {
    return _publicDomainMovies.containsKey(movieId);
  }
  
  static String getMovieArchiveId(int movieId) {
    return _publicDomainMovies[movieId] ?? '';
  }
}
