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

Current status: The app now has fixed permission handling with the ability to properly open the system settings when permissions are permanently denied. This provides a complete user flow for handling notification permissions on both iOS and Android. 