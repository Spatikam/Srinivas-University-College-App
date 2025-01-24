import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final DateTime timestamp;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      width: 300,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')} ${timestamp.toString().substring(11, 16)}',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}