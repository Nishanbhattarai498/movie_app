// Simple legal content helper for the movie app
class LegalContentHelper {
  // Get legal disclaimer text
  static String getLegalDisclaimer() {
    return '''
🎬 LEGAL CONTENT NOTICE 🎬

This app provides information about movies and links to LEGAL streaming services only.

✅ LEGAL CONTENT SOURCES:
• Official movie trailers (YouTube)
• Licensed streaming platforms (Netflix, Amazon Prime, etc.)
• Free legal services (Tubi, Crackle, etc.)
• Public domain movies (Archive.org)
• Educational documentaries

❌ ILLEGAL ACTIVITIES PROHIBITED:
• Piracy or unauthorized streaming
• Copyright infringement
• Accessing copyrighted content without permission

Always use legitimate, licensed streaming services to watch movies.
Support creators by paying for content through official channels.
''';
  }

  // Get list of free legal streaming platforms
  static List<Map<String, String>> getFreeLegalPlatforms() {
    return [
      {
        'name': 'Tubi TV',
        'url': 'https://tubitv.com',
        'description': 'Free movies and TV shows with ads',
        'type': 'Free with Ads'
      },
      {
        'name': 'Crackle',
        'url': 'https://www.crackle.com',
        'description': 'Free Sony Pictures content',
        'type': 'Free with Ads'
      },
      {
        'name': 'Pluto TV',
        'url': 'https://pluto.tv',
        'description': 'Free streaming TV and movies',
        'type': 'Free with Ads'
      },
      {
        'name': 'YouTube Movies',
        'url': 'https://www.youtube.com/movies',
        'description': 'Free movies with ads and rentals',
        'type': 'Free/Rental'
      },
      {
        'name': 'Archive.org',
        'url': 'https://archive.org/details/movies',
        'description': 'Public domain movies and documentaries',
        'type': 'Public Domain'
      }
    ];
  }

  // Get list of subscription platforms
  static List<Map<String, String>> getSubscriptionPlatforms() {
    return [
      {
        'name': 'Netflix',
        'url': 'https://www.netflix.com',
        'description': 'Global streaming service',
        'type': 'Subscription'
      },
      {
        'name': 'Amazon Prime Video',
        'url': 'https://www.amazon.com/prime-video',
        'description': 'Amazon streaming service',
        'type': 'Subscription'
      },
      {
        'name': 'Disney+',
        'url': 'https://www.disneyplus.com',
        'description': 'Disney, Marvel, Star Wars content',
        'type': 'Subscription'
      },
      {
        'name': 'Hulu',
        'url': 'https://www.hulu.com',
        'description': 'US streaming service',
        'type': 'Subscription'
      },
      {
        'name': 'HBO Max',
        'url': 'https://www.hbomax.com',
        'description': 'HBO and Warner Bros content',
        'type': 'Subscription'
      }
    ];
  }

  // Get all legal platforms
  static List<Map<String, String>> getAllLegalPlatforms() {
    return [...getFreeLegalPlatforms(), ...getSubscriptionPlatforms()];
  }

  // Check if a URL appears to be from a legal source
  static bool isLegalSource(String url) {
    final legalDomains = [
      'youtube.com',
      'youtu.be',
      'archive.org',
      'netflix.com',
      'amazon.com',
      'disneyplus.com',
      'hulu.com',
      'hbomax.com',
      'tubitv.com',
      'crackle.com',
      'pluto.tv',
      'peacocktv.com',
      'paramount.com',
      'apple.com',
      'vudu.com',
      'fandangonow.com',
      'movietickets.com',
      'commondatastorage.googleapis.com', // Google's sample videos
    ];

    return legalDomains.any((domain) => url.toLowerCase().contains(domain));
  }

  // Get educational content sources
  static List<Map<String, String>> getEducationalSources() {
    return [
      {
        'name': 'Khan Academy',
        'url': 'https://www.khanacademy.org',
        'description': 'Free educational videos and courses',
        'type': 'Educational'
      },
      {
        'name': 'MIT OpenCourseWare',
        'url': 'https://ocw.mit.edu',
        'description': 'Free MIT course materials',
        'type': 'Educational'
      },
      {
        'name': 'Archive.org Educational',
        'url': 'https://archive.org/details/opensource_movies',
        'description': 'Educational and documentary films',
        'type': 'Educational'
      },
      {
        'name': 'TED Talks',
        'url': 'https://www.ted.com',
        'description': 'Educational talks and presentations',
        'type': 'Educational'
      }
    ];
  }

  // Get Creative Commons content sources
  static List<Map<String, String>> getCreativeCommonsSources() {
    return [
      {
        'name': 'Blender Foundation',
        'url': 'https://www.blender.org/about/projects/',
        'description': 'Open source animated films',
        'type': 'Creative Commons'
      },
      {
        'name': 'Wikimedia Commons',
        'url': 'https://commons.wikimedia.org/wiki/Category:Videos',
        'description': 'Free media files',
        'type': 'Creative Commons'
      },
      {
        'name': 'Creative Commons Search',
        'url': 'https://search.creativecommons.org',
        'description': 'Search for CC-licensed content',
        'type': 'Creative Commons'
      }
    ];
  }

  // Get legal compliance tips
  static List<String> getLegalComplianceTips() {
    return [
      'Always verify content is legally available in your region',
      'Support content creators by using official channels',
      'Respect copyright laws and licensing terms',
      'Use only legitimate streaming services',
      'Report suspected copyright violations',
      'Understand fair use and educational exceptions',
      'Check Creative Commons licenses for usage rights',
      'Avoid peer-to-peer sharing of copyrighted content'
    ];
  }

  // Get trailer sources (legal)
  static List<Map<String, String>> getTrailerSources() {
    return [
      {
        'name': 'YouTube Official Channels',
        'description': 'Official movie studio channels',
        'example': 'Sony Pictures, Disney, Universal'
      },
      {
        'name': 'TMDB Trailers',
        'description': 'Trailers from The Movie Database',
        'example': 'Linked to official sources'
      },
      {
        'name': 'IMDb Trailers',
        'description': 'Trailers from Internet Movie Database',
        'example': 'Official promotional content'
      }
    ];
  }
}
