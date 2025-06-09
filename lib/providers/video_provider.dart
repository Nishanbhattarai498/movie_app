import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/streaming_source.dart';

class VideoProvider extends ChangeNotifier {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isBuffering = false;
  bool _isFullscreen = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  String _currentQuality = 'Auto';
  List<StreamingSource> _availableSources = [];
  StreamingSource? _currentSource;
  double _playbackSpeed = 1.0;
  double _volume = 1.0;
  bool _showControls = true;

  // Getters
  VideoPlayerController? get controller => _controller;
  bool get isInitialized => _isInitialized;
  bool get isPlaying => _isPlaying;
  bool get isBuffering => _isBuffering;
  bool get isFullscreen => _isFullscreen;
  Duration get position => _position;
  Duration get duration => _duration;
  String get currentQuality => _currentQuality;
  List<StreamingSource> get availableSources => _availableSources;
  double get playbackSpeed => _playbackSpeed;
  double get volume => _volume;
  bool get showControls => _showControls;

  Future<void> initializeVideo(MovieStream movieStream) async {
    try {
      _availableSources = movieStream.sources;
      _currentSource = movieStream.sources.firstWhere(
        (source) => source.isDefault,
        orElse: () => movieStream.sources.first,
      );

      _controller = VideoPlayerController.networkUrl(
        Uri.parse(_currentSource!.url),
      );

      await _controller!.initialize();
      _isInitialized = true;
      _duration = _controller!.value.duration;

      _controller!.addListener(_videoListener);
      notifyListeners();
    } catch (e) {
      print('Error initializing video: $e');
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

  Future<void> changeQuality(StreamingSource source) async {
    if (_controller != null && source.url != _currentSource?.url) {
      final currentPosition = _controller!.value.position;
      final wasPlaying = _controller!.value.isPlaying;

      await _controller!.dispose();

      _controller = VideoPlayerController.networkUrl(Uri.parse(source.url));
      await _controller!.initialize();
      await _controller!.seekTo(currentPosition);

      if (wasPlaying) {
        await _controller!.play();
      }

      _currentSource = source;
      _currentQuality = source.quality;
      _controller!.addListener(_videoListener);
      notifyListeners();
    }
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

    Future.delayed(Duration(seconds: 3), () {
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
