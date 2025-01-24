import 'package:flutter/material.dart';
import 'package:rip_college_app/screens/widget_common/notif_card.dart';

class NotifCardData {
  final String title;
  final String message;
  final DateTime timestamp;

  NotifCardData({
    required this.title,
    required this.message,
    required this.timestamp,
  });
}

class NotificationListView extends StatelessWidget {
  final List<NotifCardData> notifCardData;

  const NotificationListView({super.key, required this.notifCardData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: notifCardData.map((data) {
          return NotificationCard(
            title: data.title,
            message: data.message,
            timestamp: data.timestamp,
          );
        }).toList(),
      ),
    );
  }
}
