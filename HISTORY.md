# Project History

## April 5, 2024
- Examined the repository to understand its purpose
- Found that this is a basic Flutter project template
- The project name suggests it's intended to be an example for Flutter local notifications
- However, the flutter_local_notifications package is not yet included in the dependencies
- The main.dart file contains only the default Flutter counter app template

## April 6, 2024
- Added flutter_local_notifications package using `flutter pub add flutter_local_notifications`
- Fixed build issues by:
  1. Updated Android NDK version to 27.0.12077973 (required by the notifications package)
  2. Enabled Java 8 desugaring by adding `isCoreLibraryDesugaringEnabled = true` and the desugar dependency
  3. Updated desugar_jdk_libs from 2.0.4 to 2.1.4 as required by flutter_local_notifications

- Implemented local notifications functionality:
  1. Created `noti_service.dart` with a service class to handle notifications setup and display
  2. Created a simple `home_page.dart` with a button to trigger notifications
  3. Updated `main.dart` to initialize notifications when the app starts

- Configured iOS for notifications:
  1. Modified AppDelegate.swift to import flutter_local_notifications
  2. Added plugin registrant callback setup for notification actions
  3. Set up UNUserNotificationCenter delegate for handling notifications when the app is in foreground

- Added permission handling for notifications:
  1. Added permission_handler package (version 11.4.0)
  2. Updated AndroidManifest.xml to include POST_NOTIFICATIONS permission
  3. Added NSUserNotificationsUsageDescription to Info.plist
  4. Updated NotiService to check and request permissions before showing notifications
  5. Redesigned HomePage with permission status indicator and request button
  6. Added feedback to user when permissions are granted/denied

- Improved permission handling:
  1. Enhanced the permission request workflow to handle different permission states
  2. Added detection for permanently denied permissions
  3. Added an "Open Settings" button that appears when permissions are permanently denied
  4. Improved the UI to clearly indicate the current permission state
  5. Updated error messages to provide appropriate guidance based on permission status

- Fixed permission-related issues:
  1. Corrected the implementation of openAppSettings by renaming method to avoid naming conflict
  2. Fixed method call to use the global openAppSettings function instead of calling it through Permission class
  3. Updated references in home_page.dart to use the renamed method

- Code refactoring and best practices:
  1. Made internal methods and variables private in NotiService class
  2. Changed notificationPlugin to _notificationPlugin (private variable)
  3. Made notificationDetails method private as _notificationDetails

Current status: The app now has a well-structured implementation with proper permission handling and follows Dart best practices for private/public API design. The notification functionality is working correctly on both iOS and Android platforms. 

## April 7, 2024
- Fixed scheduled notifications implementation:
  1. Added timezone package (version 0.10.0) to properly handle scheduled notifications across different timezones
  2. Fixed the scheduleNotification method to use proper timezone handling
  3. Added timezone initialization in the initialize method
  4. Set default timezone to UTC (can be customized to user's timezone)
  5. Wrapped the notification scheduling code in try-catch block for better error handling
  6. Removed UILocalNotificationDateInterpretation parameter which was causing errors

- Added macOS support:
  1. Added macOS initialization settings in the initialize method
  2. Updated NotificationDetails to include macOS notifications
  3. Added special handling for permissions on macOS since permission_handler doesn't fully support macOS
  4. Added Platform checks to use simplified permission handling on macOS

Current status: The app now supports both immediate and scheduled notifications with proper timezone handling, making it more reliable for scheduling notifications at specific times. It also works on macOS in addition to iOS and Android. 