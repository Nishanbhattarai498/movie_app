// Educational streaming service for learning purposes
class EducationalStreamingService {
  // Simulate movie database with educational content
  static const Map<int, MockMovie> educationalMovies = {
    1: MockMovie(
      id: 1,
      title: 'Big Buck Bunny',
      description: 'Open source animated short film',
      streamUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      license: 'Creative Commons',
    ),
    2: MockMovie(
      id: 2,
      title: 'Sintel',
      description: 'Open source fantasy short film',
      streamUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
      license: 'Creative Commons',
    ),
    3: MockMovie(
      id: 3,
      title: 'Tears of Steel',
      description: 'Open source sci-fi short film',
      streamUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
      license: 'Creative Commons',
    ),
  };

  // Educational method: Simulate real streaming patterns
  static Future<List<StreamingSource>> getEducationalStreams(
      int movieId) async {
    // Simulate API delay
    await Future.delayed(Duration(seconds: 1));

    final movie = educationalMovies[movieId];
    if (movie == null) {
      throw Exception('Educational content not found');
    }

    // Return multiple quality options for educational testing
    return [
      StreamingSource(
        quality: '1080p',
        url: movie.streamUrl,
        type: 'mp4',
      ),
      StreamingSource(
        quality: '720p',
        url: movie.streamUrl,
        type: 'mp4',
      ),
      StreamingSource(
        quality: '480p',
        url: movie.streamUrl,
        type: 'mp4',
      ),
    ];
  }

  // Educational: Show how real services handle content licensing
  static bool isContentLicensed(int movieId) {
    return educationalMovies.containsKey(movieId);
  }

  // Educational: Demonstrate proper attribution
  static String getAttribution(int movieId) {
    final movie = educationalMovies[movieId];
    return movie?.license ?? 'Unknown license';
  }
}

class MockMovie {
  final int id;
  final String title;
  final String description;
  final String streamUrl;
  final String license;

  const MockMovie({
    required this.id,
    required this.title,
    required this.description,
    required this.streamUrl,
    required this.license,
  });
}
