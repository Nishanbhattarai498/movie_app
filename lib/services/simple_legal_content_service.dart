// Simple legal content sources for the movie app
class LegalContentService {
  // Get curated public domain movies
  static List<SimpleMovie> getPublicDomainMovies() {
    return [
      SimpleMovie(
        id: 'pd001',
        title: 'A Trip to the Moon (1902)',
        description:
            'Georges Méliès classic early science fiction film about a voyage to the moon.',
        year: '1902',
        rating: 8.2,
        url: 'https://archive.org/details/LeVoyageDansLaLune',
        type: 'Public Domain',
      ),
      SimpleMovie(
        id: 'pd002',
        title: 'The Cabinet of Dr. Caligari (1920)',
        description:
            'German expressionist horror film that influenced cinema history.',
        year: '1920',
        rating: 8.0,
        url: 'https://archive.org/details/CabinetOfDrCaligari',
        type: 'Public Domain',
      ),
      SimpleMovie(
        id: 'pd003',
        title: 'Night of the Living Dead (1968)',
        description: 'George A. Romero zombie classic that defined the genre.',
        year: '1968',
        rating: 7.9,
        url: 'https://archive.org/details/night_of_the_living_dead',
        type: 'Public Domain',
      ),
    ];
  }

  // Get Creative Commons videos
  static List<SimpleMovie> getCreativeCommonsVideos() {
    return [
      SimpleMovie(
        id: 'cc001',
        title: 'Big Buck Bunny',
        description: 'Open source animated short film.',
        year: '2008',
        rating: 8.5,
        url:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        type: 'Creative Commons',
      ),
      SimpleMovie(
        id: 'cc002',
        title: 'Elephants Dream',
        description: 'First open source 3D animated movie.',
        year: '2006',
        rating: 7.2,
        url:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        type: 'Creative Commons',
      ),
      SimpleMovie(
        id: 'cc003',
        title: 'Sintel',
        description: 'Fantasy adventure short film.',
        year: '2010',
        rating: 8.9,
        url:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
        type: 'Creative Commons',
      ),
    ];
  }

  // Get free streaming platforms
  static List<StreamingPlatform> getFreePlatforms() {
    return [
      StreamingPlatform(
        name: 'Tubi',
        url: 'https://tubitv.com',
        description: 'Free movies and TV shows with ads',
        type: 'free',
      ),
      StreamingPlatform(
        name: 'Crackle',
        url: 'https://www.crackle.com',
        description: 'Free Sony Pictures content',
        type: 'free',
      ),
      StreamingPlatform(
        name: 'Pluto TV',
        url: 'https://pluto.tv',
        description: 'Free streaming TV and movies',
        type: 'free',
      ),
    ];
  }

  // Get subscription platforms
  static List<StreamingPlatform> getSubscriptionPlatforms() {
    return [
      StreamingPlatform(
        name: 'Netflix',
        url: 'https://www.netflix.com',
        description: 'Global streaming service',
        type: 'subscription',
      ),
      StreamingPlatform(
        name: 'Amazon Prime Video',
        url: 'https://www.amazon.com/prime-video',
        description: 'Amazon streaming service',
        type: 'subscription',
      ),
      StreamingPlatform(
        name: 'Disney+',
        url: 'https://www.disneyplus.com',
        description: 'Disney, Marvel, Star Wars content',
        type: 'subscription',
      ),
    ];
  }

  // Get all platforms
  static List<StreamingPlatform> getAllPlatforms() {
    return [...getFreePlatforms(), ...getSubscriptionPlatforms()];
  }

  // Legal disclaimer
  static String getLegalDisclaimer() {
    return '''
🎬 LEGAL CONTENT NOTICE 🎬

This app only provides access to LEGAL content sources:

✅ LEGAL SOURCES:
• Creative Commons licensed videos
• Public domain movies (Archive.org)
• Official streaming platform information
• Educational documentaries

📖 USAGE:
• All content is either public domain or Creative Commons
• Streaming platform links are for information only
• No copyrighted material is hosted or streamed

🚀 SUPPORT CREATORS:
For the latest movies, please use legitimate streaming services.
This app is for educational and demonstration purposes only.
''';
  }
}

// Simple movie model for legal content
class SimpleMovie {
  final String id;
  final String title;
  final String description;
  final String year;
  final double rating;
  final String url;
  final String type;

  SimpleMovie({
    required this.id,
    required this.title,
    required this.description,
    required this.year,
    required this.rating,
    required this.url,
    required this.type,
  });
}

// Simple streaming platform model
class StreamingPlatform {
  final String name;
  final String url;
  final String description;
  final String type;

  StreamingPlatform({
    required this.name,
    required this.url,
    required this.description,
    required this.type,
  });
}
