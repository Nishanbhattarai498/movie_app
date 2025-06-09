import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../config/api_config.dart';

class TMDBService {
  static const String _apiKey = ApiConfig.tmdbApiKey;
  static const String _baseUrl = ApiConfig.tmdbBaseUrl;
  static const String _imageBaseUrl = ApiConfig.imageBaseUrl;
  static const String _backdropBaseUrl = ApiConfig.backdropBaseUrl;

  // Get trending movies
  static Future<List<Movie>> getTrendingMovies() async {
    final url = '$_baseUrl/trending/movie/day?api_key=$_apiKey';

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
    final url = '$_baseUrl/movie/popular?api_key=$_apiKey';

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
    final url = '$_baseUrl/movie/upcoming?api_key=$_apiKey';

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
    final url = '$_baseUrl/movie/top_rated?api_key=$_apiKey';

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
    final url = '$_baseUrl/genre/movie/list?api_key=$_apiKey';

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
}
