# YouTube Music Downloader - Lightweight Overlay

A lightweight Flutter mobile app that works as an overlay when you share YouTube videos. No searching needed - just share and download!

## Features

- 🚀 **Ultra lightweight** - minimal app size and resource usage
- 📱 **Share integration** - appears when you share YouTube videos
- 💫 **Overlay design** - doesn't leave YouTube app
- 💾 **Background downloads** - download continues in background
- 📊 **Progress tracking** - see download progress in real-time
- 🎯 **High-quality audio** - downloads best available audio quality
- 🗂️ **Auto-save** - saves to Music folder automatically

## How It Works

This app is designed to be as simple and unobtrusive as possible:
1. **Open YouTube** and find a video you want
2. **Tap Share** button in YouTube
3. **Select "YT Music Downloader"** from the share menu
4. **App opens as overlay** showing video info
5. **Tap Download** and return to YouTube
6. **File downloads in background** to your Music folder

## Installation

### Prerequisites

1. **Install Flutter**
   - Download from: https://flutter.dev/docs/get-started/install
   - Follow the installation guide for your operating system
   - Ensure Flutter is added to your PATH

2. **Set up Android Development** (for Android)
   - Install Android Studio
   - Set up an Android emulator or connect a physical device
   - Enable USB debugging on your device

3. **Set up iOS Development** (for iOS - macOS only)
   - Install Xcode
   - Set up an iOS simulator or connect a physical device

### Setup

1. **Clone/Download the project**
   ```bash
   cd youtube_music_downloader
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Usage

### Using the App
1. **Install the app** following the setup instructions below
2. **Open YouTube** and browse for music
3. **Share any video** you want to download
4. **Select this app** from the share options
5. **Tap Download** in the overlay that appears
6. **Return to YouTube** - download continues in background
7. **Find your files** in the Music folder when complete

## Technical Details

### Dependencies
- `youtube_explode_dart`: For YouTube video information and audio extraction
- `http`: For downloading files
- `path_provider`: For file system access
- `permission_handler`: For requesting storage permissions
- `receive_sharing_intent`: For handling share intents from other apps
- `flutter_background_service`: For background download processing

### File Storage
- **Android**: Files are stored in `/storage/emulated/0/Android/data/com.example.youtube_music_downloader/files/Music/`
- **iOS**: Files are stored in the app's documents directory

### Permissions
The app requires the following permissions:
- **Internet**: To search YouTube and download files
- **Storage**: To save downloaded files to your device

## Important Notes

⚠️ **Legal Disclaimer**: This app is for educational purposes only. Please respect YouTube's Terms of Service and only download content you have permission to download.

⚠️ **Copyright**: Be aware of copyright laws in your jurisdiction. Only download content that you own or have explicit permission to download.

## Troubleshooting

### Common Issues

1. **App won't install**
   - Make sure you have Flutter installed and configured
   - Check that your device/emulator is properly connected
   - Run `flutter doctor` to check for issues

2. **Downloads not working**
   - Ensure you have internet connection
   - Check that storage permissions are granted
   - Try restarting the app

3. **Audio won't play**
   - Check that the file downloaded completely
   - Ensure your device supports the audio format
   - Try downloading the file again

### Getting Help

If you encounter issues:
1. Run `flutter doctor` to check your Flutter installation
2. Check the console output for error messages
3. Ensure all dependencies are properly installed with `flutter pub get`

## Development

### Project Structure
```
lib/
├── main.dart                   # App entry point and share intent handling
├── models/
│   └── video.dart             # Video data model
├── services/
│   ├── youtube_service.dart   # YouTube API interactions
│   └── download_service.dart  # File download handling
└── screens/
    └── download_overlay.dart  # Download overlay interface
```

### Key Features
- **Minimal UI**: Only shows when needed via share intent
- **Background Processing**: Downloads continue after closing overlay
- **Smart File Naming**: Automatically cleans and names downloaded files
- **Progress Tracking**: Real-time download progress with percentage
- **Error Handling**: Graceful handling of network and permission issues

### Building for Release

**Android APK:**
```bash
flutter build apk --release
```

**iOS (macOS only):**
```bash
flutter build ios --release
```

## License

This project is for educational purposes. Please respect YouTube's Terms of Service and applicable copyright laws.
