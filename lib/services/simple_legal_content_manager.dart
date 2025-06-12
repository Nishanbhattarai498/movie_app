import '../services/tmdb_service.dart';
import '../services/simple_legal_content_service.dart';

class SimpleLegalContentManager {
  // Get all legal content for a movie
  static Future<SimpleLegalContent> getLegalContent(int movieId) async {
    try {
      final trailers = await TMDBService.getMovieTrailers(movieId);
      final streamingSources =
          await TMDBService.getLegalStreamingSources(movieId);

      return SimpleLegalContent(
        trailers: trailers,
        streamingSources: streamingSources,
        publicDomainMovies: LegalContentService.getPublicDomainMovies(),
        creativeCommonsVideos: LegalContentService.getCreativeCommonsVideos(),
        freePlatforms: LegalContentService.getFreePlatforms(),
      );
    } catch (e) {
      // Return basic content if API fails
      return SimpleLegalContent(
        trailers: [],
        streamingSources: [],
        publicDomainMovies: LegalContentService.getPublicDomainMovies(),
        creativeCommonsVideos: LegalContentService.getCreativeCommonsVideos(),
        freePlatforms: LegalContentService.getFreePlatforms(),
      );
    }
  }

  // Get streaming recommendations
  static List<StreamingRecommendation> getStreamingRecommendations() {
    return [
      StreamingRecommendation(
        category: 'Free with Ads',
        platforms: LegalContentService.getFreePlatforms(),
        description: 'Watch movies for free with advertisements',
      ),
      StreamingRecommendation(
        category: 'Subscription Services',
        platforms: LegalContentService.getSubscriptionPlatforms(),
        description: 'Monthly subscription for ad-free viewing',
      ),
    ];
  }

  // Check if content source is legal
  static bool isLegalSource(String url) {
    final legalDomains = [
      'youtube.com',
      'archive.org',
      'netflix.com',
      'amazon.com',
      'disneyplus.com',
      'tubitv.com',
      'crackle.com',
      'pluto.tv',
      'commondatastorage.googleapis.com',
    ];

    return legalDomains.any((domain) => url.contains(domain));
  }

  // Get legal disclaimer
  static String getLegalDisclaimer() {
    return LegalContentService.getLegalDisclaimer();
  }
}

// Simple data models
class SimpleLegalContent {
  final List<TrailerInfo> trailers;
  final List<LegalStreamingSource> streamingSources;
  final List<SimpleMovie> publicDomainMovies;
  final List<SimpleMovie> creativeCommonsVideos;
  final List<StreamingPlatform> freePlatforms;

  SimpleLegalContent({
    required this.trailers,
    required this.streamingSources,
    required this.publicDomainMovies,
    required this.creativeCommonsVideos,
    required this.freePlatforms,
  });
}

class StreamingRecommendation {
  final String category;
  final List<StreamingPlatform> platforms;
  final String description;

  StreamingRecommendation({
    required this.category,
    required this.platforms,
    required this.description,
  });
}
