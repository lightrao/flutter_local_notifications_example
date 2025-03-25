import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotiService {
  // Singleton instance
  static final NotiService _instance = NotiService._internal();
  
  // Factory constructor
  factory NotiService() => _instance;
  
  // Private constructor
  NotiService._internal();
  
  final FlutterLocalNotificationsPlugin _notificationPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // initialize
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone data
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('UTC'));  // You can replace 'UTC' with your timezone if needed

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
    await _notificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        _handleNotificationTap(response);
      },
    );
    _isInitialized = true;
  }

  void _handleNotificationTap(NotificationResponse response) {
    // Add logic to handle notification taps
    // For example, navigate to a specific screen based on the payload
    final payload = response.payload;
    if (payload != null) {
      // Process payload
    }
  }

  // Request notification permissions
  Future<PermissionStatus> requestPermissions() async {
    // For Android, we need to request the notification permission
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
    try {
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
    } catch (e) {
      print('Error showing notification: $e');
      return false;
    }
  }

  Future<bool> scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    try {
      final hasPermission = await checkPermissions();
      
      if (!hasPermission) {
        final permissionRequested = await requestPermissions();
        if (!permissionRequested.isGranted) {
          return false;
        }
      }
      
      await _notificationPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
      
      return true;
    } catch (e) {
      print('Error scheduling notification: $e');
      return false;
    }
  }

  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notificationPlugin.cancel(id);
  }

  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notificationPlugin.cancelAll();
  }
}
