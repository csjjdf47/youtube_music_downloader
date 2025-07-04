import 'package:flutter/material.dart';
import '../services/youtube_service.dart';
import '../services/download_service.dart';

class DownloadOverlay extends StatefulWidget {
  final String youtubeUrl;

  DownloadOverlay({required this.youtubeUrl});

  @override
  _DownloadOverlayState createState() => _DownloadOverlayState();
}

class _DownloadOverlayState extends State<DownloadOverlay> {
  final YouTubeService _youTubeService = YouTubeService();
  final DownloadService _downloadService = DownloadService();
  
  bool _isLoading = true;
  bool _isDownloading = false;
  bool _downloadCompleted = false;
  double _downloadProgress = 0.0;
  String? _videoTitle;
  String? _videoAuthor;
  String? _thumbnailUrl;
  String? _videoId;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadVideoInfo();
  }

  @override
  void dispose() {
    _youTubeService.dispose();
    _downloadService.dispose();
    super.dispose();
  }

  Future<void> _loadVideoInfo() async {
    try {
      // Extract video ID from URL
      final videoId = _extractVideoId(widget.youtubeUrl);
      if (videoId == null) {
        setState(() {
          _errorMessage = 'Invalid YouTube URL';
          _isLoading = false;
        });
        return;
      }

      _videoId = videoId;
      
      // Get video information
      final title = await _youTubeService.getVideoTitle(videoId);
      
      setState(() {
        _videoTitle = title ?? 'Unknown Title';
        _videoAuthor = 'YouTube Video';
        _thumbnailUrl = 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading video: $e';
        _isLoading = false;
      });
    }
  }

  String? _extractVideoId(String url) {
    final patterns = [
      RegExp(r'youtube\.com.*[?&]v=([^&]+)'),
      RegExp(r'youtu\.be\/([^?]+)'),
      RegExp(r'youtube\.com\/embed\/([^?]+)'),
    ];
    
    for (final pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null) {
        return match.group(1);
      }
    }
    return null;
  }

  Future<void> _downloadVideo() async {
    if (_videoId == null || _videoTitle == null) return;

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    try {
      final success = await _downloadService.downloadAudio(
        _videoId!,
        _videoTitle!,
        (progress) {
          setState(() {
            _downloadProgress = progress;
          });
        },
      );

      setState(() {
        _isDownloading = false;
        _downloadCompleted = success;
      });

      if (success) {
        // Show success for a moment, then close
        await Future.delayed(Duration(seconds: 2));
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _errorMessage = 'Download failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.download_rounded, color: Colors.white, size: 24),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Download YouTube Audio',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              // Content
              Padding(
                padding: EdgeInsets.all(20),
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Column(
        children: [
          CircularProgressIndicator(color: Colors.red),
          SizedBox(height: 20),
          Text('Loading video information...'),
        ],
      );
    }

    if (_errorMessage != null) {
      return Column(
        children: [
          Icon(Icons.error, color: Colors.red, size: 50),
          SizedBox(height: 20),
          Text(
            _errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      );
    }

    if (_downloadCompleted) {
      return Column(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 50),
          SizedBox(height: 20),
          Text(
            'Download completed!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: 10),
          Text('File saved to Music folder'),
        ],
      );
    }

    return Column(
      children: [
        // Video thumbnail and info
        if (_thumbnailUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              _thumbnailUrl!,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  color: Colors.grey[300],
                  child: Icon(Icons.music_note, size: 50),
                );
              },
            ),
          ),
        
        SizedBox(height: 15),
        
        // Video title
        Text(
          _videoTitle ?? 'Loading...',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        
        SizedBox(height: 5),
        
        Text(
          _videoAuthor ?? '',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        
        SizedBox(height: 20),
        
        // Download progress
        if (_isDownloading) ...[
          LinearProgressIndicator(
            value: _downloadProgress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
          SizedBox(height: 10),
          Text('${(_downloadProgress * 100).toInt()}% downloaded'),
          SizedBox(height: 20),
        ],
        
        // Download button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isDownloading ? null : _downloadVideo,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: _isDownloading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Downloading...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  )
                : Text(
                    'Download Audio',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
          ),
        ),
        
        SizedBox(height: 10),
        
        // Cancel button
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }
}
