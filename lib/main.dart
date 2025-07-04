import 'package:flutter/material.dart';
// import 'package:receive_sharing_intent/receive_sharing_intent.dart';
// import 'dart:async';
import 'screens/download_overlay.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YT Music Downloader',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // late StreamSubscription _intentDataStreamSubscription;
  // String? _sharedText;

  @override
  void initState() {
    super.initState();
    
    // Manually handle any initial shared content
    /// Future implementation of manual sharing handler needed here
    /// if applicable based on newer receive_sharing_intent usage.

    /// Comments added to remember where updates are needed.
    // _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream().listen((String value) {
    //   setState(() {
    //     _sharedText = value;
    //   });
    //   _handleSharedContent(value);
    // }, onError: (err) {
    //   print("Error receiving shared content: $err");
    // });

    // ReceiveSharingIntent.getInitialText().then((String? value) {
    //   if (value != null) {
    //     setState(() {
    //       _sharedText = value;
    //     });
    //     _handleSharedContent(value);
    //   }
    // });
  }

  @override
  void dispose() {
    // _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  void _handleSharedContent(String content) {
    // Check if the shared content is a YouTube URL
    if (content.contains('youtube.com') || content.contains('youtu.be')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DownloadOverlay(youtubeUrl: content),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.download_rounded,
              size: 80,
              color: Colors.red,
            ),
            SizedBox(height: 20),
            Text(
              'YouTube Music Downloader',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Share a YouTube video to this app to download it as audio',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'How to use:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '1. Open YouTube app\n2. Find a video you want to download\n3. Tap the Share button\n4. Select "YT Music Downloader"\n5. Tap Download and return to YouTube',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Test button for manual URL input
            ElevatedButton(
              onPressed: () {
                _handleSharedContent('https://www.youtube.com/watch?v=dQw4w9WgXcQ');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text(
                'Test Download (Rick Roll)',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

