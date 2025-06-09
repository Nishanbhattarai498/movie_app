class StreamingSource {
  final String quality;
  final String url;
  final String type; // 'mp4', 'hls', 'm3u8'
  final bool isDefault;

  StreamingSource({
    required this.quality,
    required this.url,
    required this.type,
    this.isDefault = false,
  });
}

class MovieStream {
  final int movieId;
  final String title;
  final List<StreamingSource> sources;
  final List<Subtitle> subtitles;
  final String thumbnailUrl;
  final int duration; // in seconds

  MovieStream({
    required this.movieId,
    required this.title,
    required this.sources,
    required this.subtitles,
    required this.thumbnailUrl,
    required this.duration,
  });
}

class Subtitle {
  final String language;
  final String url;
  final String label;

  Subtitle({required this.language, required this.url, required this.label});
}

class WatchProgress {
  final int movieId;
  final int currentPosition; // in seconds
  final int totalDuration;
  final DateTime lastWatched;
  final bool isCompleted;

  WatchProgress({
    required this.movieId,
    required this.currentPosition,
    required this.totalDuration,
    required this.lastWatched,
    this.isCompleted = false,
  });

  double get progressPercentage => currentPosition / totalDuration;
}
