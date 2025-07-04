import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class DownloadService {
  final YoutubeExplode _yt = YoutubeExplode();

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      return status.isGranted;
    }
    return true;
  }

  Future<String> getDownloadDirectory() async {
    Directory? directory;
    
    if (Platform.isAndroid) {
      // Try to get the Music directory in external storage
      directory = Directory('/storage/emulated/0/Music');
      if (!await directory.exists()) {
        // Fallback to app directory
        directory = await getExternalStorageDirectory();
        final musicDir = Directory('${directory!.path}/Music');
        if (!await musicDir.exists()) {
          await musicDir.create(recursive: true);
        }
        return musicDir.path;
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
      final musicDir = Directory('${directory.path}/Music');
      if (!await musicDir.exists()) {
        await musicDir.create(recursive: true);
      }
      return musicDir.path;
    }
    
    return directory.path;
  }

  Future<bool> downloadAudio(String videoId, String title, Function(double) onProgress) async {
    try {
      // Request storage permission
      if (!await requestStoragePermission()) {
        print('Storage permission denied');
        return false;
      }

      // Get audio stream
      final manifest = await _yt.videos.streamsClient.getManifest(videoId);
      final audioStreams = manifest.audioOnly;
      
      if (audioStreams.isEmpty) {
        print('No audio stream found');
        return false;
      }
      
      final audioStream = audioStreams.withHighestBitrate();

      // Get download directory
      final downloadDir = await getDownloadDirectory();
      
      // Clean filename and ensure .mp3 extension
      final cleanTitle = title.replaceAll(RegExp(r'[^\w\s-]'), '').trim();
      final fileName = '$cleanTitle.mp3';
      final filePath = '$downloadDir/$fileName';

      print('Downloading to: $filePath');

      // Start downloading with progress tracking
      final stream = _yt.videos.streamsClient.get(audioStream);
      final file = File(filePath);
      final sink = file.openWrite();
      
      final contentLength = audioStream.size.totalBytes;
      var downloadedBytes = 0;
      
      await for (final chunk in stream) {
        sink.add(chunk);
        downloadedBytes += chunk.length;
        
        if (contentLength > 0) {
          final progress = downloadedBytes / contentLength;
          onProgress(progress);
        }
      }
      
      await sink.close();
      onProgress(1.0); // Ensure 100% completion
      
      print('Download completed: $filePath');
      return true;
      
    } catch (e) {
      print('Error downloading audio: $e');
      return false;
    }
  }

  Future<List<FileSystemEntity>> getDownloadedFiles() async {
    try {
      final downloadDir = await getDownloadDirectory();
      final directory = Directory(downloadDir);
      
      if (await directory.exists()) {
        return directory.listSync().where((file) => file is File).toList();
      }
      
      return [];
    } catch (e) {
      print('Error getting downloaded files: $e');
      return [];
    }
  }

  void dispose() {
    _yt.close();
  }
}
