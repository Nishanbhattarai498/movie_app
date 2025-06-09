class ApiConfig {
  // Get your API key from https://www.themoviedb.org/settings/api
  // 1. Go to https://www.themoviedb.org/
  // 2. Create an account or login
  // 3. Go to Settings > API
  // 4. Request an API key
  // 5. Replace the value below with your actual API key
  static const String tmdbApiKey = 'YOUR_TMDB_API_KEY_HERE';
  
  // TMDB API endpoints
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String backdropBaseUrl = 'https://image.tmdb.org/t/p/w1280';
  static const String originalImageUrl = 'https://image.tmdb.org/t/p/original';
}
