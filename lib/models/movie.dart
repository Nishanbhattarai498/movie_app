class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final List<String> genres;
  final List<int> genreIds;
  final int runtime;
  final String? trailerUrl;
  final String? originalLanguage;
  final double popularity;
  final int voteCount;
  final bool adult;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genres,
    this.genreIds = const [],
    this.runtime = 0,
    this.trailerUrl,
    this.originalLanguage,
    this.popularity = 0.0,
    this.voteCount = 0,
    this.adult = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      genres: List<String>.from(json['genres'] ?? []),
      runtime: json['runtime'] ?? 0,
      trailerUrl: json['trailer_url'],
    );
  }

  // Factory constructor for TMDB API responses (movie list)
  factory Movie.fromTMDBJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      genres: [], // Will be populated from genre_ids separately
      genreIds: List<int>.from(json['genre_ids'] ?? []),
      originalLanguage: json['original_language'],
      popularity: (json['popularity'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      adult: json['adult'] ?? false,
    );
  }

  // Factory constructor for TMDB movie details API response
  factory Movie.fromTMDBDetailJson(Map<String, dynamic> json) {
    List<String> genreNames = [];
    if (json['genres'] != null) {
      genreNames = (json['genres'] as List)
          .map((genre) => genre['name'] as String)
          .toList();
    }

    String? trailerUrl;
    if (json['videos'] != null && json['videos']['results'] != null) {
      final videos = json['videos']['results'] as List;
      final trailer = videos.firstWhere(
        (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
        orElse: () => null,
      );
      if (trailer != null) {
        trailerUrl = 'https://www.youtube.com/watch?v=${trailer['key']}';
      }
    }

    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
      genres: genreNames,
      runtime: json['runtime'] ?? 0,
      trailerUrl: trailerUrl,
      originalLanguage: json['original_language'],
      popularity: (json['popularity'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      adult: json['adult'] ?? false,
    );
  }

  String get fullPosterPath {
    if (posterPath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }
  
  String get fullBackdropPath {
    if (backdropPath.isEmpty) return '';
    return 'https://image.tmdb.org/t/p/w1280$backdropPath';
  }

  String get formattedReleaseDate {
    if (releaseDate.isEmpty) return 'Unknown';
    try {
      final date = DateTime.parse(releaseDate);
      return '${date.year}';
    } catch (e) {
      return releaseDate;
    }
  }

  String get formattedRating => voteAverage.toStringAsFixed(1);

  String get formattedRuntime {
    if (runtime == 0) return 'Unknown';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
