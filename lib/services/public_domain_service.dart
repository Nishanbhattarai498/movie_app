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
    3: 'TheManWithTheMovieCamera', // The Man with the Movie Camera
    4: 'Metropolis1927', // Metropolis (1927) - corrected ID
    5: 'Charade_Cary_Grant_Audrey_Hepburn_1963', // Charade (1963)
    6: 'His_Girl_Friday_1940', // His Girl Friday
    7: 'cc_1940_the_great_dictator', // The Great Dictator
    8: 'DuckandCover1951', // Duck and Cover
    9: 'ReeferMadness1936', // Reefer Madness
    10: 'The_phantom_of_the_opera_1925', // Phantom of the Opera (1925)
  };
  static Future<List<StreamingSource>> getMovieStreams(int movieId) async {
    final archiveId = _publicDomainMovies[movieId];
    if (archiveId == null) {
      print('No archive ID found for movie ID: $movieId');
      return _getFallbackStreams();
    }

    print('Fetching streams for movie ID: $movieId, archive ID: $archiveId');

    try {
      final url = '$_baseUrl/$archiveId';
      print('API URL: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API response received, parsing streams...');
        final sources = _parseArchiveStreams(data, archiveId);
        print('Found ${sources.length} streaming sources');
        return sources;
      } else {
        print('API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error fetching streams: $e');
    }

    print('Falling back to demo streams');
    return _getFallbackStreams();
  }
  static List<StreamingSource> _parseArchiveStreams(
      Map<String, dynamic> data, String archiveId) {
    final List<StreamingSource> sources = [];
    
    print('Parsing streams for archive: $archiveId');

    if (data['files'] != null) {
      final files = data['files'] as Map<String, dynamic>;
      print('Found ${files.length} files in archive');

      files.forEach((filename, fileData) {
        final format = fileData['format']?.toString().toLowerCase() ?? '';
        final source = fileData['source']?.toString().toLowerCase() ?? '';
        
        print('File: $filename, Format: $format, Source: $source');
        
        // Look for video files in various formats
        if (format.contains('mpeg4') || 
            format.contains('mp4') ||
            format.contains('h.264') ||
            format.contains('video') ||
            filename.toLowerCase().endsWith('.mp4') ||
            filename.toLowerCase().endsWith('.avi') ||
            filename.toLowerCase().endsWith('.mkv')) {
          
          final size = fileData['size']?.toString() ?? '';
          String quality = 'SD';

          // Determine quality based on filename and size
          if (filename.contains('1080p') || filename.contains('HD')) {
            quality = '1080p';
          } else if (filename.contains('720p')) {
            quality = '720p';
          } else if (filename.contains('480p')) {
            quality = '480p';
          } else if (size.isNotEmpty) {
            // Estimate quality based on file size
            final sizeNum = int.tryParse(size) ?? 0;
            if (sizeNum > 1000000000) { // > 1GB
              quality = '1080p';
            } else if (sizeNum > 500000000) { // > 500MB
              quality = '720p';
            } else if (sizeNum > 100000000) { // > 100MB
              quality = '480p';
            }
          }

          final streamingSource = StreamingSource(
            quality: quality,
            url: 'https://archive.org/download/$archiveId/$filename',
            type: 'mp4',
          );
          
          sources.add(streamingSource);
          print('Added streaming source: ${streamingSource.quality} - ${streamingSource.url}');
        }
      });
    } else {
      print('No files found in API response');
    }

    // Sort by quality (highest first)
    sources.sort((a, b) {
      const qualityOrder = {'1080p': 3, '720p': 2, '480p': 1, 'SD': 0};
      return (qualityOrder[b.quality] ?? 0) - (qualityOrder[a.quality] ?? 0);
    });

    print('Total streaming sources found: ${sources.length}');
    return sources.isNotEmpty ? sources : _getFallbackStreams();
  }

  static List<StreamingSource> _getFallbackStreams() {
    // Fallback to demo streams if no real content is available
    return [
      StreamingSource(
        quality: '1080p',
        url:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        type: 'mp4',
      ),
      StreamingSource(
        quality: '720p',
        url:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        type: 'mp4',
      ),
      StreamingSource(
        quality: '480p',
        url:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
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

  // Test function to verify archive IDs
  static Future<void> testArchiveIds() async {
    final testIds = [
      'night_of_the_living_dead_1968',
      'plan_9_from_outer_space',
      'Metropolis1927',
      'metropolis_1927',
      'Charade_Cary_Grant_Audrey_Hepburn_1963',
      'His_Girl_Friday_1940',
    ];

    for (final id in testIds) {
      print('\n=== Testing Archive ID: $id ===');
      try {
        final response = await http.get(
          Uri.parse('$_baseUrl/$id'),
          headers: {'Accept': 'application/json'},
        );
        
        print('Status: ${response.statusCode}');
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['files'] != null) {
            final files = data['files'] as Map<String, dynamic>;
            print('Found ${files.length} files');
            
            int videoCount = 0;
            files.forEach((filename, fileData) {
              final format = fileData['format']?.toString() ?? '';
              if (format.toLowerCase().contains('mp4') || 
                  format.toLowerCase().contains('mpeg4') ||
                  filename.toLowerCase().endsWith('.mp4')) {
                videoCount++;
                print('Video file: $filename (${format})');
              }
            });
            print('Video files found: $videoCount');
          } else {
            print('No files metadata found');
          }
        } else {
          print('Error: ${response.body}');
        }
      } catch (e) {
        print('Exception: $e');
      }
    }
  }
}
