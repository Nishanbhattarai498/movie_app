import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';

class MovieProvider extends ChangeNotifier {
  List<Movie> _trendingMovies = [];
  List<Movie> _popularMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Movie> _topRatedMovies = [];
  List<Movie> _searchResults = [];
  Map<int, String> _genres = {};
  bool _isLoading = false;
  String _error = '';

  List<Movie> get trendingMovies => _trendingMovies;
  List<Movie> get popularMovies => _popularMovies;
  List<Movie> get upcomingMovies => _upcomingMovies;
  List<Movie> get topRatedMovies => _topRatedMovies;
  List<Movie> get searchResults => _searchResults;
  Map<int, String> get genres => _genres;
  bool get isLoading => _isLoading;
  String get error => _error;

  MovieProvider() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await loadGenres();
    await Future.wait([
      loadTrendingMovies(),
      loadPopularMovies(),
      loadUpcomingMovies(),
      loadTopRatedMovies(),
    ]);
  }

  Future<void> loadGenres() async {
    try {
      _genres = await TMDBService.getGenres();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadTrendingMovies() async {
    _setLoading(true);
    try {
      _trendingMovies = await TMDBService.getTrendingMovies();
      _populateGenreNames(_trendingMovies);
      _error = '';
    } catch (e) {
      _error = e.toString();
      _trendingMovies = _getFallbackMovies('trending');
    }
    _setLoading(false);
  }

  Future<void> loadPopularMovies() async {
    _setLoading(true);
    try {
      _popularMovies = await TMDBService.getPopularMovies();
      _populateGenreNames(_popularMovies);
      _error = '';
    } catch (e) {
      _error = e.toString();
      _popularMovies = _getFallbackMovies('popular');
    }
    _setLoading(false);
  }

  Future<void> loadUpcomingMovies() async {
    _setLoading(true);
    try {
      _upcomingMovies = await TMDBService.getUpcomingMovies();
      _populateGenreNames(_upcomingMovies);
      _error = '';
    } catch (e) {
      _error = e.toString();
      _upcomingMovies = _getFallbackMovies('upcoming');
    }
    _setLoading(false);
  }

  Future<void> loadTopRatedMovies() async {
    _setLoading(true);
    try {
      _topRatedMovies = await TMDBService.getTopRatedMovies();
      _populateGenreNames(_topRatedMovies);
      _error = '';
    } catch (e) {
      _error = e.toString();
      _topRatedMovies = _getFallbackMovies('top_rated');
    }
    _setLoading(false);
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      _searchResults = await TMDBService.searchMovies(query);
      _populateGenreNames(_searchResults);
      _error = '';
    } catch (e) {
      _error = e.toString();
      _searchResults = [];
    }
    _setLoading(false);
  }

  Future<Movie?> getMovieDetails(int movieId) async {
    try {
      return await TMDBService.getMovieDetails(movieId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  void _populateGenreNames(List<Movie> movies) {
    for (int i = 0; i < movies.length; i++) {
      final movie = movies[i];
      if (movie.genreIds.isNotEmpty && _genres.isNotEmpty) {
        final genreNames = movie.genreIds
            .map((id) => _genres[id])
            .where((name) => name != null)
            .cast<String>()
            .toList();

        // Create updated movie with genre names
        movies[i] = Movie(
          id: movie.id,
          title: movie.title,
          overview: movie.overview,
          posterPath: movie.posterPath,
          backdropPath: movie.backdropPath,
          voteAverage: movie.voteAverage,
          releaseDate: movie.releaseDate,
          genres: genreNames,
          genreIds: movie.genreIds,
          runtime: movie.runtime,
          trailerUrl: movie.trailerUrl,
          originalLanguage: movie.originalLanguage,
          popularity: movie.popularity,
          voteCount: movie.voteCount,
          adult: movie.adult,
        );
      }
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Fallback mock data in case API fails
  List<Movie> _getFallbackMovies(String category) {
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

  Future<void> refreshAllData() async {
    _setLoading(true);
    await _loadInitialData();
    _setLoading(false);
  }

  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}
