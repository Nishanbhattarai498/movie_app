import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../models/movie.dart';
import '../models/streaming_source.dart';
import '../providers/video_provider.dart';
import '../providers/watch_history_provider.dart';
import '../widgets/video_controls.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Movie movie;

  const VideoPlayerScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoProvider videoProvider;
  late WatchHistoryProvider watchHistoryProvider;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    videoProvider = Provider.of<VideoProvider>(context, listen: false);
    watchHistoryProvider = Provider.of<WatchHistoryProvider>(
      context,
      listen: false,
    );

    // Keep screen awake during video playback
    WakelockPlus.enable();

    // Set landscape orientation for better viewing
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);    // Hide system UI for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _initializeRealVideo();
  }

  Future<void> _initializeVideo() async {
    // Create mock streaming data - in real app, fetch from your backend
    final movieStream = MovieStream(
      movieId: widget.movie.id,
      title: widget.movie.title,
      sources: [
        StreamingSource(
          quality: 'Auto',
          url:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          type: 'mp4',
          isDefault: true,
        ),
        StreamingSource(
          quality: '1080p',
          url:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          type: 'mp4',
        ),
        StreamingSource(
          quality: '720p',
          url:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
          type: 'mp4',
        ),
        StreamingSource(
          quality: '480p',
          url:
              'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
          type: 'mp4',
        ),
      ],
      subtitles: [
        Subtitle(language: 'en', url: '', label: 'English'),
        Subtitle(language: 'es', url: '', label: 'Spanish'),
      ],
      thumbnailUrl: widget.movie.fullPosterPath,
      duration: 7200, // 2 hours in seconds
    );

    await videoProvider.initializeVideo(movieStream);

    // Resume from last watched position if available
    final watchProgress = watchHistoryProvider.getWatchProgress(
      widget.movie.id,
    );
    if (watchProgress != null && watchProgress.currentPosition > 30) {
      await videoProvider.seekTo(
        Duration(seconds: watchProgress.currentPosition),
      );

      // Show resume dialog
      _showResumeDialog(watchProgress);
    }

    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _initializeRealVideo() async {
    try {
      // Try to load real movie streaming first
      await videoProvider.initializeMovieStreaming(widget.movie.id);

      // Resume from last watched position if available
      final watchProgress = watchHistoryProvider.getWatchProgress(
        widget.movie.id,
      );
      if (watchProgress != null && watchProgress.currentPosition > 30) {
        await videoProvider.seekTo(
          Duration(seconds: watchProgress.currentPosition),
        );

        // Show resume dialog
        _showResumeDialog(watchProgress);
      }

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing video: $e');
      // Fall back to demo content
      await _initializeVideo();
    }
  }

  void _showResumeDialog(WatchProgress progress) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Resume Watching'),
        content: Text(
          'Do you want to resume from ${_formatDuration(Duration(seconds: progress.currentPosition))}?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              videoProvider.seekTo(Duration.zero);
            },
            child: Text('Start Over'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Already seeked to the position
            },
            child: Text('Resume'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<VideoProvider>(
        builder: (context, videoProvider, child) {
          if (!_isInitialized || !videoProvider.isInitialized) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Loading ${widget.movie.title}...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // Video Player
              Center(
                child: AspectRatio(
                  aspectRatio: videoProvider.controller!.value.aspectRatio,
                  child: GestureDetector(
                    onTap: () {
                      if (videoProvider.showControls) {
                        videoProvider.toggleControls();
                      } else {
                        videoProvider.showControlsTemporarily();
                      }
                    },
                    child: VideoPlayer(videoProvider.controller!),
                  ),
                ),
              ),

              // Video Controls Overlay
              if (videoProvider.showControls)
                VideoControls(movie: widget.movie, onBack: _handleBack),

              // Loading indicator when buffering
              if (videoProvider.isBuffering)
                Center(child: CircularProgressIndicator(color: Colors.white)),
            ],
          );
        },
      ),
    );
  }

  void _handleBack() async {
    // Save watch progress before leaving
    final currentPosition = videoProvider.position.inSeconds;
    final totalDuration = videoProvider.duration.inSeconds;

    if (currentPosition > 30) {
      // Only save if watched for more than 30 seconds
      await watchHistoryProvider.updateWatchProgress(
        widget.movie.id,
        currentPosition,
        totalDuration,
      );
    }

    Navigator.pop(context);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  void dispose() {
    // Restore system UI and orientation
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Disable wakelock
    WakelockPlus.disable();

    super.dispose();
  }
}
