import 'package:flutter/material.dart';
import 'package:flutter_local_notifications_example/noti_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            NotiService().showNotification(
              id: 0,
              title: 'Hello',
              body: 'This is a test notification',
            );
          },
          child: const Text('Send Notification'),
        ),
      ),
    );
  }
}
