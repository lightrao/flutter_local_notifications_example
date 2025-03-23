import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotiService {
  final FlutterLocalNotificationsPlugin _notificationPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // initialize
  Future<void> initialize() async {
    if (_isInitialized) return;

    // prepare android initialization settings
    const androidInitializationSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // prepare ios initialization settings
    const iosInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: false, // We'll request manually
      requestBadgePermission: false, // We'll request manually
      requestSoundPermission: false, // We'll request manually
    );

    // prepare initialization settings
    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    // finally initialize the plugin
    await _notificationPlugin.initialize(initializationSettings);
    _isInitialized = true;
  }

  // Request notification permissions
  Future<PermissionStatus> requestPermissions() async {
    // For Android 13 and above (API level 33), we need to request the notification permission
    final status = await Permission.notification.request();
    return status;
  }

  // Check if permission is granted
  Future<bool> checkPermissions() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  // Check if permission is permanently denied
  Future<bool> isPermanentlyDenied() async {
    final status = await Permission.notification.status;
    return status.isPermanentlyDenied;
  }

  // Open app settings
  Future<bool> openSettings() async {
    return await openAppSettings();
  }

  // notification details setup
  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription: 'Daily notifications channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // show notification with permission check
  Future<bool> showNotification({int id = 0, String? title, String? body}) async {
    // First check if we have permission
    final hasPermission = await checkPermissions();
    
    if (!hasPermission) {
      // Try to request permission if we don't have it
      final permissionRequested = await requestPermissions();
      if (!permissionRequested.isGranted) {
        // User denied permission
        return false;
      }
    }
    
    // We have permission, show the notification
    await _notificationPlugin.show(
      id,
      title,
      body,
      _notificationDetails(),
    );
    
    return true;
  }
}
