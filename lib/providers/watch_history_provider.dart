import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/streaming_source.dart';
import '../models/movie.dart';

class WatchHistoryProvider extends ChangeNotifier {
  List<WatchProgress> _watchHistory = [];
  List<Movie> _continueWatching = [];

  List<WatchProgress> get watchHistory => _watchHistory;
  List<Movie> get continueWatching => _continueWatching;

  WatchHistoryProvider() {
    _loadWatchHistory();
  }

  Future<void> updateWatchProgress(
    int movieId,
    int currentPosition,
    int totalDuration,
  ) async {
    final existingIndex = _watchHistory.indexWhere(
      (progress) => progress.movieId == movieId,
    );

    final newProgress = WatchProgress(
      movieId: movieId,
      currentPosition: currentPosition,
      totalDuration: totalDuration,
      lastWatched: DateTime.now(),
      isCompleted:
          currentPosition >= totalDuration * 0.9, // 90% watched = completed
    );

    if (existingIndex >= 0) {
      _watchHistory[existingIndex] = newProgress;
    } else {
      _watchHistory.add(newProgress);
    }

    // Sort by last watched (most recent first)
    _watchHistory.sort((a, b) => b.lastWatched.compareTo(a.lastWatched));

    await _saveWatchHistory();
    notifyListeners();
  }

  WatchProgress? getWatchProgress(int movieId) {
    try {
      return _watchHistory.firstWhere(
        (progress) => progress.movieId == movieId,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> removeFromHistory(int movieId) async {
    _watchHistory.removeWhere((progress) => progress.movieId == movieId);
    await _saveWatchHistory();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _watchHistory.clear();
    await _saveWatchHistory();
    notifyListeners();
  }

  Future<void> _loadWatchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('watch_history');

      if (historyJson != null) {
        final List<dynamic> historyList = json.decode(historyJson);
        _watchHistory = historyList
            .map(
              (item) => WatchProgress(
                movieId: item['movieId'],
                currentPosition: item['currentPosition'],
                totalDuration: item['totalDuration'],
                lastWatched: DateTime.parse(item['lastWatched']),
                isCompleted: item['isCompleted'] ?? false,
              ),
            )
            .toList();

        notifyListeners();
      }
    } catch (e) {
      print('Error loading watch history: $e');
    }
  }

  Future<void> _saveWatchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = json.encode(
        _watchHistory
            .map(
              (progress) => {
                'movieId': progress.movieId,
                'currentPosition': progress.currentPosition,
                'totalDuration': progress.totalDuration,
                'lastWatched': progress.lastWatched.toIso8601String(),
                'isCompleted': progress.isCompleted,
              },
            )
            .toList(),
      );

      await prefs.setString('watch_history', historyJson);
    } catch (e) {
      print('Error saving watch history: $e');
    }
  }
}
