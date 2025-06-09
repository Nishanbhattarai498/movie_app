import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/movie.dart';
import '../providers/video_provider.dart';

class VideoControls extends StatefulWidget {
  final Movie movie;
  final VoidCallback onBack;

  const VideoControls({Key? key, required this.movie, required this.onBack})
    : super(key: key);

  @override
  _VideoControlsState createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {
  bool _showQualityMenu = false;
  bool _showSpeedMenu = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoProvider>(
      builder: (context, videoProvider, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
          child: Column(
            children: [
              // Top Controls
              _buildTopControls(videoProvider),

              Expanded(
                child: Center(child: _buildCenterControls(videoProvider)),
              ),

              // Bottom Controls
              _buildBottomControls(videoProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopControls(VideoProvider videoProvider) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: widget.onBack,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Quality: ${videoProvider.currentQuality}',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            // Quality Menu
            PopupMenuButton<String>(
              icon: Icon(Icons.settings, color: Colors.white),
              color: Colors.black87,
              onSelected: (value) {
                if (value == 'quality') {
                  _showQualityDialog(videoProvider);
                } else if (value == 'speed') {
                  _showSpeedDialog(videoProvider);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'quality',
                  child: Row(
                    children: [
                      Icon(Icons.high_quality, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Quality', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'speed',
                  child: Row(
                    children: [
                      Icon(Icons.speed, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Speed', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterControls(VideoProvider videoProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.replay_10, color: Colors.white, size: 40),
          onPressed: () {
            final newPosition = videoProvider.position - Duration(seconds: 10);
            videoProvider.seekTo(
              newPosition < Duration.zero ? Duration.zero : newPosition,
            );
          },
        ),
        SizedBox(width: 32),
        Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              videoProvider.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 48,
            ),
            onPressed: () {
              if (videoProvider.isPlaying) {
                videoProvider.pause();
              } else {
                videoProvider.play();
              }
            },
          ),
        ),
        SizedBox(width: 32),
        IconButton(
          icon: Icon(Icons.forward_10, color: Colors.white, size: 40),
          onPressed: () {
            final newPosition = videoProvider.position + Duration(seconds: 10);
            videoProvider.seekTo(
              newPosition > videoProvider.duration
                  ? videoProvider.duration
                  : newPosition,
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomControls(VideoProvider videoProvider) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress Bar
            Row(
              children: [
                Text(
                  _formatDuration(videoProvider.position),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.red,
                      inactiveTrackColor: Colors.white.withOpacity(0.3),
                      thumbColor: Colors.red,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
                    ),
                    child: Slider(
                      value: videoProvider.position.inSeconds.toDouble(),
                      max: videoProvider.duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        videoProvider.seekTo(Duration(seconds: value.toInt()));
                      },
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  _formatDuration(videoProvider.duration),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Bottom Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.volume_up, color: Colors.white),
                      onPressed: () => _showVolumeDialog(videoProvider),
                    ),
                    IconButton(
                      icon: Icon(Icons.closed_caption, color: Colors.white),
                      onPressed: () {
                        // Toggle subtitles
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Subtitles feature coming soon!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.picture_in_picture, color: Colors.white),
                      onPressed: () {
                        // Enable PiP mode
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Picture-in-Picture mode activated!'),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.fullscreen, color: Colors.white),
                      onPressed: () {
                        videoProvider.toggleFullscreen();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showQualityDialog(VideoProvider videoProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: Text('Select Quality', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: videoProvider.availableSources.map((source) {
            return ListTile(
              title: Text(
                source.quality,
                style: TextStyle(color: Colors.white),
              ),
              trailing: videoProvider.currentQuality == source.quality
                  ? Icon(Icons.check, color: Colors.red)
                  : null,
              onTap: () {
                videoProvider.changeQuality(source);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showSpeedDialog(VideoProvider videoProvider) {
    final speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: Text('Playback Speed', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: speeds.map((speed) {
            return ListTile(
              title: Text('${speed}x', style: TextStyle(color: Colors.white)),
              trailing: videoProvider.playbackSpeed == speed
                  ? Icon(Icons.check, color: Colors.red)
                  : null,
              onTap: () {
                videoProvider.setPlaybackSpeed(speed);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showVolumeDialog(VideoProvider videoProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: Text('Volume', style: TextStyle(color: Colors.white)),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Slider(
                  value: videoProvider.volume,
                  onChanged: (value) {
                    videoProvider.setVolume(value);
                    setState(() {});
                  },
                  activeColor: Colors.red,
                  inactiveColor: Colors.white.withOpacity(0.3),
                ),
                Text(
                  '${(videoProvider.volume * 100).round()}%',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
    } else {
      return '$twoDigitMinutes:$twoDigitSeconds';
    }
  }
}
