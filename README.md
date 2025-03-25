# Flutter Local Notifications Example

A simple Flutter app that demonstrates how to implement local notifications in Flutter applications for Android, iOS, and macOS platforms.

## Features

- 📱 Show immediate notifications on demand
- ⏰ Schedule notifications for future delivery
- 🔒 Proper permission handling for all platforms
- 🌐 Support for timezone-aware scheduling
- 🖥️ Cross-platform support (Android, iOS, macOS)
- 🔄 Singleton service pattern for easy access

## Setup Instructions

### Requirements

- Flutter (latest stable version)
- Android Studio / Xcode (for platform-specific development)

### Install Dependencies

```bash
flutter pub get
```

### Platform Configuration

#### Android

Ensure the following permissions are added in your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

For Android 13 (API level 33) and above, the app will request this permission at runtime.

#### iOS

In your `Info.plist`, add:

```xml
<key>NSUserNotificationUsageDescription</key>
<string>This app needs to show notifications.</string>
```

#### macOS

Add similar permission settings in your `Info.plist` for macOS.

## Usage

### Basic Notification

```dart
// Initialize the service (already done in main.dart)
await NotiService().initialize();

// Show a basic notification
await NotiService().showNotification(
  id: 0, 
  title: 'Hello', 
  body: 'This is a test notification'
);
```

### Scheduled Notification

```dart
await NotiService().scheduleNotification(
  id: 1,
  title: 'Reminder',
  body: 'This is a scheduled notification',
  scheduledDate: DateTime.now().add(const Duration(seconds: 5)),
);
```

### Cancel Notifications

```dart
// Cancel a specific notification
await NotiService().cancelNotification(id);

// Cancel all notifications
await NotiService().cancelAllNotifications();
```

## Architecture

The app uses a simple but effective architecture:

- `noti_service.dart`: A singleton service that encapsulates all notification functionality
- `home_page.dart`: UI for demonstration and testing notifications
- `main.dart`: App entry point that initializes the notification service

## Permissions

The app handles permissions gracefully:
1. Checks if permission is already granted
2. If not, requests permission with clear user dialog
3. If permanently denied, provides a button to open app settings

## Supporting Multiple Platforms

The code includes specific handling for different platforms:
- Android: Uses specific Android notification settings
- iOS: Uses DarwinNotificationDetails
- macOS: Special handling due to permission_handler limitations

## Contributing

Feel free to fork this repository and submit pull requests for improvements.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
