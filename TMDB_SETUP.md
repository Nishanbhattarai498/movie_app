# TMDB API Setup Instructions

To use real movie data from The Movie Database (TMDB), follow these steps:

## Step 1: Get Your TMDB API Key

1. Go to [https://www.themoviedb.org/](https://www.themoviedb.org/)
2. Create a free account or login if you already have one
3. Go to your account Settings > API
4. Request an API key (choose "Developer" for personal/learning projects)
5. Fill out the application form with your project details
6. Once approved, you'll receive your API key

## Step 2: Configure Your API Key

1. Open `lib/config/api_config.dart`
2. Replace `YOUR_TMDB_API_KEY_HERE` with your actual API key:

```dart
static const String tmdbApiKey = 'your_actual_api_key_here';
```

## Step 3: Test the Integration

1. Run your Flutter app: `flutter run`
2. The app should now load real movie data from TMDB
3. If you see errors, check:
   - Your internet connection
   - Your API key is correct
   - TMDB API service is accessible

## Features Available

With TMDB integration, your app now supports:

- ✅ Trending movies
- ✅ Popular movies  
- ✅ Upcoming movies
- ✅ Top-rated movies
- ✅ Movie search
- ✅ Detailed movie information
- ✅ Movie genres
- ✅ High-quality movie posters and backdrops
- ✅ Real ratings and release dates

## Troubleshooting

### Common Issues:

1. **"Invalid API key"** - Double-check your API key in `api_config.dart`
2. **"No internet connection"** - Check your device's internet connection
3. **"Request timeout"** - TMDB servers might be busy, try again later
4. **Empty movie lists** - Check if your API key has the right permissions

### Fallback Behavior:

If the API fails, the app will show mock data so it continues to work offline.

## API Rate Limits

TMDB free tier allows:
- 1,000 requests per day
- 50 requests per hour

This is more than enough for development and testing.
