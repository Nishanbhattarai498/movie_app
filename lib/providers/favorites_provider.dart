import 'package:flutter/material.dart';
import '../models/movie.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Movie> _favorites = [];

  List<Movie> get favorites => _favorites;

  bool isFavorite(Movie movie) {
    return _favorites.any((fav) => fav.id == movie.id);
  }

  void toggleFavorite(Movie movie) {
    if (isFavorite(movie)) {
      _favorites.removeWhere((fav) => fav.id == movie.id);
    } else {
      _favorites.add(movie);
    }
    notifyListeners();
  }
}
