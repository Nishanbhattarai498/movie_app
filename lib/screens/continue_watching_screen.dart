import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/watch_history_provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/continue_watching_card.dart';

class ContinueWatchingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Continue Watching'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Clear History'),
                onTap: () {
                  Provider.of<WatchHistoryProvider>(
                    context,
                    listen: false,
                  ).clearHistory();
                },
              ),
            ],
          ),
        ],
      ),
      body: Consumer2<WatchHistoryProvider, MovieProvider>(
        builder: (context, watchHistoryProvider, movieProvider, child) {
          final watchHistory = watchHistoryProvider.watchHistory
              .where((progress) => !progress.isCompleted)
              .toList();

          if (watchHistory.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_circle_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No movies in progress',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Start watching a movie to see it here',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: watchHistory.length,
            itemBuilder: (context, index) {
              final progress = watchHistory[index];
              final movie = movieProvider.getMovieById(progress.movieId);

              if (movie == null) return SizedBox.shrink();

              return ContinueWatchingCard(movie: movie, progress: progress);
            },
          );
        },
      ),
    );
  }
}
