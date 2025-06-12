import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../config/api_config.dart';

// Legal content sources model
class LegalStreamingSource {
  final String name;
  final String url;
  final String type; // 'free', 'rental', 'subscription'
  final String logo;

  LegalStreamingSource({
    required this.name,
    required this.url,
    required this.type,
    required this.logo,
  });
}

class TrailerInfo {
  final String key;
  final String name;
  final String site;
  final String type;
  final bool official;

  TrailerInfo({
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    required this.official,
  });

  factory TrailerInfo.fromJson(Map<String, dynamic> json) {
    return TrailerInfo(
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
      official: json['official'] ?? false,
    );
  }

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$key';
}

class TMDBService {
  static const String _apiKey = ApiConfig.tmdbApiKey;
  static const String _baseUrl = ApiConfig.tmdbBaseUrl;
  static const String _imageBaseUrl = ApiConfig.imageBaseUrl;
  static const String _backdropBaseUrl = ApiConfig.backdropBaseUrl;
  // Get trending movies
  static Future<List<Movie>> getTrendingMovies() async {
    const url = '$_baseUrl/trending/movie/day?api_key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        return results.map((json) => Movie.fromTMDBJson(json)).toList();
      } else {
        throw Exception('Failed to load trending movies');
      }
    } catch (e) {
      throw Exception('Error fetching trending movies: $e');
    }
  }

  // Get popular movies
  static Future<List<Movie>> getPopularMovies() async {
    const url = '$_baseUrl/movie/popular?api_key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        return results.map((json) => Movie.fromTMDBJson(json)).toList();
      } else {
        throw Exception('Failed to load popular movies');
      }
    } catch (e) {
      throw Exception('Error fetching popular movies: $e');
    }
  }

  // Get upcoming movies
  static Future<List<Movie>> getUpcomingMovies() async {
    const url = '$_baseUrl/movie/upcoming?api_key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        return results.map((json) => Movie.fromTMDBJson(json)).toList();
      } else {
        throw Exception('Failed to load upcoming movies');
      }
    } catch (e) {
      throw Exception('Error fetching upcoming movies: $e');
    }
  }

  // Get top rated movies
  static Future<List<Movie>> getTopRatedMovies() async {
    const url = '$_baseUrl/movie/top_rated?api_key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        return results.map((json) => Movie.fromTMDBJson(json)).toList();
      } else {
        throw Exception('Failed to load top rated movies');
      }
    } catch (e) {
      throw Exception('Error fetching top rated movies: $e');
    }
  }

  // Search movies
  static Future<List<Movie>> searchMovies(String query) async {
    final url =
        '$_baseUrl/search/movie?api_key=$_apiKey&query=${Uri.encodeComponent(query)}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        return results.map((json) => Movie.fromTMDBJson(json)).toList();
      } else {
        throw Exception('Failed to search movies');
      }
    } catch (e) {
      throw Exception('Error searching movies: $e');
    }
  }

  // Get movie details
  static Future<Movie> getMovieDetails(int movieId) async {
    final url =
        '$_baseUrl/movie/$movieId?api_key=$_apiKey&append_to_response=videos';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Movie.fromTMDBDetailJson(data);
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (e) {
      throw Exception('Error fetching movie details: $e');
    }
  }

  // Get movie genres
  static Future<Map<int, String>> getGenres() async {
    const url = '$_baseUrl/genre/movie/list?api_key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> genres = data['genres'];

        Map<int, String> genreMap = {};
        for (var genre in genres) {
          genreMap[genre['id']] = genre['name'];
        }

        return genreMap;
      } else {
        throw Exception('Failed to load genres');
      }
    } catch (e) {
      throw Exception('Error fetching genres: $e');
    }
  }

  // Helper methods for image URLs
  static String getImageUrl(String path, {bool isBackdrop = false}) {
    if (path.isEmpty) return '';
    final baseUrl = isBackdrop ? _backdropBaseUrl : _imageBaseUrl;
    return '$baseUrl$path';
  }

  // Get movie trailers (YouTube only for legal content)
  static Future<List<TrailerInfo>> getMovieTrailers(int movieId) async {
    final url = '$_baseUrl/movie/$movieId/videos?api_key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        // Filter for YouTube trailers only (legal content)
        return results
            .where((video) => video['site'] == 'YouTube')
            .map((json) => TrailerInfo.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load movie trailers');
      }
    } catch (e) {
      throw Exception('Error fetching movie trailers: $e');
    }
  }

  // Get legal streaming sources using JustWatch API integration
  static Future<List<LegalStreamingSource>> getLegalStreamingSources(
      int movieId) async {
    // Note: This would require JustWatch API or similar legal streaming service
    // For now, we'll return mock legal sources as examples

    // In a real implementation, you would integrate with:
    // - JustWatch API for streaming availability
    // - Archive.org for public domain content
    // - YouTube for trailers and educational content

    return [
      LegalStreamingSource(
        name: 'Netflix',
        url: 'https://www.netflix.com',
        type: 'subscription',
        logo: 'https://images.justwatch.com/icon/190848813/s100/netflix.webp',
      ),
      LegalStreamingSource(
        name: 'Amazon Prime Video',
        url: 'https://www.amazon.com/prime-video',
        type: 'subscription',
        logo:
            'https://images.justwatch.com/icon/52449861/s100/amazon-prime-video.webp',
      ),
      LegalStreamingSource(
        name: 'Disney+',
        url: 'https://www.disneyplus.com',
        type: 'subscription',
        logo:
            'https://images.justwatch.com/icon/147638351/s100/disney-plus.webp',
      ),
      LegalStreamingSource(
        name: 'Tubi (Free)',
        url: 'https://tubitv.com',
        type: 'free',
        logo: 'https://images.justwatch.com/icon/169478387/s100/tubi.webp',
      ),
      LegalStreamingSource(
        name: 'Crackle (Free)',
        url: 'https://www.crackle.com',
        type: 'free',
        logo: 'https://images.justwatch.com/icon/190848942/s100/crackle.webp',
      ),
    ];
  }

  // Get public domain movies from Archive.org
  static Future<List<Movie>> getPublicDomainMovies() async {
    // This would integrate with Archive.org Internet Archive API
    // For educational purposes, returning curated public domain content

    final List<Map<String, dynamic>> publicDomainMovies = [
      {
        'id': 999001,
        'title': 'A Trip to the Moon (1902)',
        'overview':
            'Georges Méliès\' classic early science fiction film about a voyage to the moon.',
        'poster_path': '',
        'backdrop_path': '',
        'release_date': '1902-09-01',
        'vote_average': 8.2,
        'genre_ids': [878], // Sci-Fi
        'public_domain_url': 'https://archive.org/details/LeVoyageDansLaLune',
      },
      {
        'id': 999002,
        'title': 'The Cabinet of Dr. Caligari (1920)',
        'overview':
            'German expressionist horror film that influenced cinema history.',
        'poster_path': '',
        'backdrop_path': '',
        'release_date': '1920-02-26',
        'vote_average': 8.0,
        'genre_ids': [27], // Horror
        'public_domain_url': 'https://archive.org/details/CabinetOfDrCaligari',
      },
      {
        'id': 999003,
        'title': 'Night of the Living Dead (1968)',
        'overview':
            'George A. Romero\'s zombie classic that defined the genre.',
        'poster_path': '',
        'backdrop_path': '',
        'release_date': '1968-10-01',
        'vote_average': 7.9,
        'genre_ids': [27], // Horror
        'public_domain_url':
            'https://archive.org/details/night_of_the_living_dead',
      },
    ];

    return publicDomainMovies.map((json) => Movie.fromTMDBJson(json)).toList();
  }

  // Get educational content recommendations
  static Future<List<Movie>> getEducationalMovies() async {
    // Search for educational and documentary content
    final List<String> educationalQueries = [
      'documentary',
      'educational',
      'nature',
      'science',
      'history',
    ];

    List<Movie> allEducationalMovies = [];

    for (String query in educationalQueries) {
      try {
        final movies = await searchMovies(query);
        // Filter for highly rated educational content
        final filteredMovies =
            movies.where((movie) => movie.voteAverage > 7.0).take(3).toList();
        allEducationalMovies.addAll(filteredMovies);
      } catch (e) {
        // Continue if one search fails
        continue;
      }
    }

    // Remove duplicates and return top educational movies
    final Set<int> seenIds = <int>{};
    return allEducationalMovies
        .where((movie) => seenIds.add(movie.id))
        .take(10)
        .toList();
  }

  // Get movie watch providers (legal streaming services)
  static Future<Map<String, dynamic>> getWatchProviders(
      int movieId, String country) async {
    final url = '$_baseUrl/movie/$movieId/watch/providers?api_key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as Map<String, dynamic>;

        // Return providers for specified country (default US)
        return results[country] ?? results['US'] ?? {};
      } else {
        throw Exception('Failed to load watch providers');
      }
    } catch (e) {
      throw Exception('Error fetching watch providers: $e');
    }
  }

  // Legal disclaimer helper
  static String getLegalDisclaimer() {
    return '''
🚨 LEGAL NOTICE 🚨

This app provides information about movies and links to LEGAL streaming services only.

✅ LEGAL CONTENT SOURCES:
• Official movie trailers (YouTube)
• Licensed streaming platforms (Netflix, Amazon Prime, etc.)
• Free legal services (Tubi, Crackle, etc.)
• Public domain movies (Archive.org)
• Educational documentaries

❌ ILLEGAL ACTIVITIES PROHIBITED:
• Piracy or unauthorized streaming
• Copyright infringement
• Accessing copyrighted content without permission

Always use legitimate, licensed streaming services to watch movies.
Support creators by paying for content through official channels.
    ''';
  }
}
