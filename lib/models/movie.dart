class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;
  final List<String> genres;
  final int runtime;
  final String? trailerUrl;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genres,
    this.runtime = 0,
    this.trailerUrl,
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

  String get fullPosterPath => 'https://image.tmdb.org/t/p/w500$posterPath';
  String get fullBackdropPath =>
      'https://image.tmdb.org/t/p/w1280$backdropPath';
}
