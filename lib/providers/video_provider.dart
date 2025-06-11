import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoProvider extends ChangeNotifier {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isBuffering = false;
  bool _isFullscreen = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _playbackSpeed = 1.0;
  double _volume = 1.0;
  bool _showControls = true;

  // Demo video URLs for all movies
  static const List<String> _demoVideos = [
    'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
  ];

  // Getters
  VideoPlayerController? get controller => _controller;
  bool get isInitialized => _isInitialized;
  bool get isPlaying => _isPlaying;
  bool get isBuffering => _isBuffering;
  bool get isFullscreen => _isFullscreen;
  Duration get position => _position;
  Duration get duration => _duration;
  double get playbackSpeed => _playbackSpeed;
  double get volume => _volume;
  bool get showControls => _showControls;

  // Simple method to initialize demo video for any movie
  Future<void> initializeMovieVideo(int movieId) async {
    try {
      // Use movie ID to pick a demo video (cycle through available videos)
      final videoIndex = movieId % _demoVideos.length;
      final videoUrl = _demoVideos[videoIndex];

      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await _controller!.initialize();

      _isInitialized = true;
      _duration = _controller!.value.duration;
      _controller!.addListener(_videoListener);

      notifyListeners();
    } catch (e) {
      print('Error initializing video: $e');
      _isInitialized = false;
      notifyListeners();
    }
  }

  void _videoListener() {
    if (_controller != null) {
      _position = _controller!.value.position;
      _isPlaying = _controller!.value.isPlaying;
      _isBuffering = _controller!.value.isBuffering;
      notifyListeners();
    }
  }

  Future<void> play() async {
    await _controller?.play();
    _isPlaying = true;
    notifyListeners();
  }

  Future<void> pause() async {
    await _controller?.pause();
    _isPlaying = false;
    notifyListeners();
  }

  Future<void> seekTo(Duration position) async {
    await _controller?.seekTo(position);
    _position = position;
    notifyListeners();
  }

  void setPlaybackSpeed(double speed) {
    _controller?.setPlaybackSpeed(speed);
    _playbackSpeed = speed;
    notifyListeners();
  }

  void setVolume(double volume) {
    _controller?.setVolume(volume);
    _volume = volume;
    notifyListeners();
  }

  void toggleFullscreen() {
    _isFullscreen = !_isFullscreen;
    notifyListeners();
  }

  void toggleControls() {
    _showControls = !_showControls;
    notifyListeners();
  }

  void showControlsTemporarily() {
    _showControls = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 3), () {
      if (_isPlaying) {
        _showControls = false;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }
}
