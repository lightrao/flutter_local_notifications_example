import 'package:flutter/material.dart';
import 'package:flutter_local_notifications_example/noti_service.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotiService _notiService = NotiService();
  bool _permissionGranted = false;
  bool _permissionPermanentlyDenied = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final hasPermission = await _notiService.checkPermissions();
    final isPermanentlyDenied = await _notiService.isPermanentlyDenied();
    
    setState(() {
      _permissionGranted = hasPermission;
      _permissionPermanentlyDenied = isPermanentlyDenied;
    });
  }

  Future<void> _requestPermission() async {
    final status = await _notiService.requestPermissions();
    
    if (status.isGranted) {
      setState(() {
        _permissionGranted = true;
        _permissionPermanentlyDenied = false;
      });
      _showSuccessMessage("Permission granted!");
    } else if (status.isDenied) {
      setState(() {
        _permissionGranted = false;
        _permissionPermanentlyDenied = false;
      });
      _showErrorMessage("Permission denied. Can't send notifications.");
    } else if (status.isPermanentlyDenied) {
      setState(() {
        _permissionGranted = false;
        _permissionPermanentlyDenied = true;
      });
      _showErrorMessage("Permission permanently denied. Please enable from settings.");
    }
  }

  Future<void> _openSettings() async {
    final opened = await _notiService.openSettings();
    if (opened) {
      _showSuccessMessage("Settings opened. Please enable notifications.");
    } else {
      _showErrorMessage("Could not open settings.");
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Example'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _permissionGranted ? Icons.notifications_active : Icons.notifications_off,
              size: 80,
              color: _permissionGranted ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              _permissionGranted 
                ? 'Notification Permission Granted' 
                : _permissionPermanentlyDenied
                  ? 'Notification Permission Permanently Denied'
                  : 'Notification Permission Required',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            if (!_permissionGranted) 
              _permissionPermanentlyDenied
                ? ElevatedButton(
                    onPressed: _openSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Open Settings'),
                  )
                : ElevatedButton(
                    onPressed: _requestPermission,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Grant Permission'),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final result = await _notiService.showNotification(
                  id: 0, 
                  title: 'Hello', 
                  body: 'This is a test notification'
                );
                
                if (result) {
                  _showSuccessMessage('Notification sent!');
                } else {
                  _showErrorMessage('Failed to send notification. Permission denied.');
                  await _checkPermission();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Send Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
