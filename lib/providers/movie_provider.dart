import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieProvider extends ChangeNotifier {
  List<Movie> _trendingMovies = [];
  List<Movie> _popularMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Movie> _searchResults = [];
  bool _isLoading = false;

  List<Movie> get trendingMovies => _trendingMovies;
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get upcomingMovies => _upcomingMovies;
  List<Movie> get searchResults => _searchResults;
  bool get isLoading => _isLoading;

  MovieProvider() {
    _loadMovies();
  }

  void _loadMovies() {
    // Mock data - In real app, fetch from TMDB API
    _trendingMovies = _getMockMovies('trending');
    _popularMovies = _getMockMovies('popular');
    _upcomingMovies = _getMockMovies('upcoming');
    notifyListeners();
  }

  List<Movie> _getMockMovies(String category) {
    return List.generate(10, (index) {
      return Movie(
        id: index + (category.hashCode * 100),
        title: '$category Movie ${index + 1}',
        overview:
            'This is a great $category movie with an amazing storyline that will keep you entertained throughout.',
        posterPath: '/placeholder.jpg',
        backdropPath: '/placeholder.jpg',
        voteAverage: 7.5 + (index * 0.2),
        releaseDate: '2024-0${(index % 12) + 1}-15',
        genres: ['Action', 'Adventure', 'Drama'],
        runtime: 120 + (index * 5),
        trailerUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
      );
    });
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    _searchResults = _getMockMovies('search')
        .where(
          (movie) => movie.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    _isLoading = false;
    notifyListeners();
  }

  Movie? getMovieById(int id) {
    final allMovies = [
      ..._trendingMovies,
      ..._popularMovies,
      ..._upcomingMovies,
    ];
    try {
      return allMovies.firstWhere((movie) => movie.id == id);
    } catch (e) {
      return null;
    }
  }
}
