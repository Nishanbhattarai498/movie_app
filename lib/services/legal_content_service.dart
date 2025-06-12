// Simple legal content sources
class LegalContentService {
  // Get curated public domain movies
  static List<ArchiveOrgMovie> getPublicDomainMovies() {
    return [
      ArchiveOrgMovie(
        identifier: 'A_Trip_to_the_Moon_1902',
        title: 'A Trip to the Moon (1902)',
        description:
            'Georges Méliès classic early science fiction film about a voyage to the moon.',
        year: '1902',
        rating: 8.2,
        watchUrl: 'https://archive.org/details/LeVoyageDansLaLune',
        downloadUrl:
            'https://archive.org/download/LeVoyageDansLaLune/LeVoyageDansLaLune.mp4',
      ),
      ArchiveOrgMovie(
        identifier: 'Cabinet_of_Dr_Caligari_1920',
        title: 'The Cabinet of Dr. Caligari (1920)',
        description:
            'German expressionist horror film that influenced cinema history.',
        year: '1920',
        rating: 8.0,
        watchUrl: 'https://archive.org/details/CabinetOfDrCaligari',
        downloadUrl:
            'https://archive.org/download/CabinetOfDrCaligari/CabinetOfDrCaligari.mp4',
      ),
      ArchiveOrgMovie(
        identifier: 'Night_of_the_Living_Dead_1968',
        title: 'Night of the Living Dead (1968)',
        description: 'George A. Romero zombie classic that defined the genre.',
        year: '1968',
        rating: 7.9,
        watchUrl: 'https://archive.org/details/night_of_the_living_dead',
        downloadUrl:
            'https://archive.org/download/night_of_the_living_dead/night_of_the_living_dead.mp4',
      ),
      ArchiveOrgMovie(
        identifier: 'Plan_9_from_Outer_Space_1959',
        title: 'Plan 9 from Outer Space (1959)',
        description:
            'Ed Wood\'s cult classic B-movie about aliens and zombies.',
        year: '1959',
        rating: 4.0,
        watchUrl: 'https://archive.org/details/Plan9FromOuterSpace',
        downloadUrl:
            'https://archive.org/download/Plan9FromOuterSpace/Plan9FromOuterSpace.mp4',
      ),
      ArchiveOrgMovie(
        identifier: 'Charade_1963',
        title: 'Charade (1963)',
        description: 'Cary Grant and Audrey Hepburn in a romantic thriller.',
        year: '1963',
        rating: 7.9,
        watchUrl: 'https://archive.org/details/Charade_Cary_Grant',
        downloadUrl:
            'https://archive.org/download/Charade_Cary_Grant/Charade_Cary_Grant.mp4',
      ),
    ];
  }
}

// Model for Archive.org movies
class ArchiveOrgMovie {
  final String identifier;
  final String title;
  final String description;
  final String year;
  final double rating;
  final String watchUrl;
  final String downloadUrl;

  ArchiveOrgMovie({
    required this.identifier,
    required this.title,
    required this.description,
    required this.year,
    required this.rating,
    required this.watchUrl,
    required this.downloadUrl,
  });

  factory ArchiveOrgMovie.fromJson(Map<String, dynamic> json) {
    return ArchiveOrgMovie(
      identifier: json['identifier'] ?? '',
      title: json['title'] ?? 'Unknown Title',
      description: json['description'] ?? 'No description available',
      year: json['date'] ?? 'Unknown',
      rating: (json['avg_rating'] ?? 0.0).toDouble(),
      watchUrl: 'https://archive.org/details/${json['identifier']}',
      downloadUrl:
          'https://archive.org/download/${json['identifier']}/${json['identifier']}.mp4',
    );
  }
}

// YouTube Educational Service
class YouTubeEducationalService {
  // Note: In a real app, you would use YouTube Data API v3
  // This is a simplified version with curated educational content

  static List<YouTubeEducationalVideo> getCuratedEducationalVideos() {
    return [
      YouTubeEducationalVideo(
        id: 'edu001',
        title: 'History of Cinema: Silent Era',
        description: 'Educational documentary about the early days of cinema.',
        youtubeId:
            'dQw4w9WgXcQ', // Placeholder - replace with real educational video IDs
        channelName: 'Film Education',
        duration: '45:30',
        category: 'Documentary',
      ),
      YouTubeEducationalVideo(
        id: 'edu002',
        title: 'How Movies Are Made',
        description: 'Behind the scenes look at film production.',
        youtubeId: 'dQw4w9WgXcQ', // Placeholder
        channelName: 'FilmMaking 101',
        duration: '32:15',
        category: 'Educational',
      ),
      YouTubeEducationalVideo(
        id: 'edu003',
        title: 'Animation Techniques Through History',
        description: 'Evolution of animation from hand-drawn to CGI.',
        youtubeId: 'dQw4w9WgXcQ', // Placeholder
        channelName: 'Animation Academy',
        duration: '28:45',
        category: 'Animation',
      ),
    ];
  }

  static String getYouTubeEmbedUrl(String videoId) {
    return 'https://www.youtube.com/embed/$videoId';
  }

  static String getYouTubeWatchUrl(String videoId) {
    return 'https://www.youtube.com/watch?v=$videoId';
  }
}

class YouTubeEducationalVideo {
  final String id;
  final String title;
  final String description;
  final String youtubeId;
  final String channelName;
  final String duration;
  final String category;

  YouTubeEducationalVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.youtubeId,
    required this.channelName,
    required this.duration,
    required this.category,
  });
}

// Creative Commons Video Service
class CreativeCommonsService {
  static List<CreativeCommonsVideo> getCreativeCommonsVideos() {
    return [
      CreativeCommonsVideo(
        id: 'cc001',
        title: 'Big Buck Bunny',
        description: 'Open source animated short film.',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        thumbnailUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg',
        license: 'CC BY 3.0',
        creator: 'Blender Foundation',
        year: '2008',
        duration: '9:56',
      ),
      CreativeCommonsVideo(
        id: 'cc002',
        title: 'Elephants Dream',
        description: 'First open source 3D animated movie.',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        thumbnailUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg',
        license: 'CC BY 2.5',
        creator: 'Blender Foundation',
        year: '2006',
        duration: '10:53',
      ),
      CreativeCommonsVideo(
        id: 'cc003',
        title: 'Sintel',
        description: 'Fantasy adventure short film.',
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
        thumbnailUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/Sintel.jpg',
        license: 'CC BY 3.0',
        creator: 'Blender Foundation',
        year: '2010',
        duration: '14:48',
      ),
    ];
  }
}

class CreativeCommonsVideo {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final String license;
  final String creator;
  final String year;
  final String duration;

  CreativeCommonsVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.license,
    required this.creator,
    required this.year,
    required this.duration,
  });
}

// Legal Streaming Platform Service
class LegalStreamingPlatformService {
  static List<StreamingPlatform> getAllPlatforms() {
    return [
      // Free platforms
      StreamingPlatform(
        id: 'tubi',
        name: 'Tubi',
        type: 'free',
        url: 'https://tubitv.com',
        logo: 'https://images.justwatch.com/icon/169478387/s100/tubi.webp',
        description: 'Free movies and TV shows with ads',
        countries: ['US', 'CA', 'AU'],
      ),
      StreamingPlatform(
        id: 'crackle',
        name: 'Crackle',
        type: 'free',
        url: 'https://www.crackle.com',
        logo: 'https://images.justwatch.com/icon/190848942/s100/crackle.webp',
        description: 'Free Sony Pictures content',
        countries: ['US'],
      ),
      StreamingPlatform(
        id: 'pluto',
        name: 'Pluto TV',
        type: 'free',
        url: 'https://pluto.tv',
        logo: 'https://images.justwatch.com/icon/190848813/s100/pluto-tv.webp',
        description: 'Free streaming TV and movies',
        countries: ['US', 'CA', 'EU'],
      ),

      // Subscription platforms
      StreamingPlatform(
        id: 'netflix',
        name: 'Netflix',
        type: 'subscription',
        url: 'https://www.netflix.com',
        logo: 'https://images.justwatch.com/icon/190848813/s100/netflix.webp',
        description: 'Global streaming service',
        countries: ['US', 'CA', 'EU', 'AU', 'GLOBAL'],
      ),
      StreamingPlatform(
        id: 'amazon-prime',
        name: 'Amazon Prime Video',
        type: 'subscription',
        url: 'https://www.amazon.com/prime-video',
        logo:
            'https://images.justwatch.com/icon/52449861/s100/amazon-prime-video.webp',
        description: 'Amazon\'s streaming service',
        countries: ['US', 'CA', 'EU', 'AU', 'GLOBAL'],
      ),
      StreamingPlatform(
        id: 'disney-plus',
        name: 'Disney+',
        type: 'subscription',
        url: 'https://www.disneyplus.com',
        logo:
            'https://images.justwatch.com/icon/147638351/s100/disney-plus.webp',
        description: 'Disney, Marvel, Star Wars content',
        countries: ['US', 'CA', 'EU', 'AU'],
      ),
    ];
  }

  static List<StreamingPlatform> getFreePlatforms() {
    return getAllPlatforms()
        .where((platform) => platform.type == 'free')
        .toList();
  }

  static List<StreamingPlatform> getSubscriptionPlatforms() {
    return getAllPlatforms()
        .where((platform) => platform.type == 'subscription')
        .toList();
  }
}

class StreamingPlatform {
  final String id;
  final String name;
  final String type;
  final String url;
  final String logo;
  final String description;
  final List<String> countries;

  StreamingPlatform({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    required this.logo,
    required this.description,
    required this.countries,
  });
}
