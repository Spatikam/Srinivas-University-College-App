import 'package:flutter/material.dart';
import 'package:rip_college_app/screens/widget_common/notif_card_list.dart';
import 'package:rip_college_app/screens/widget_common/post_card_list.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    final List<PostCardData> postCards = [
      PostCardData(
        imagePath: 'assets/images/image.png',
        title: 'Post 1',
        description: 'Description for Post 1',
      ),
      PostCardData(
        imagePath: 'assets/images/image.png',
        title: 'Post 2',
        description: 'Description for Post 2',
      ),
      PostCardData(
        imagePath: 'assets/images/image.png',
        title: 'Post 3',
        description: 'Description for Post 3',
      ),
      // Add more PostCardData objects as needed
    ];

    List<NotifCardData> notificationsList = [
      NotifCardData(
        title: 'New Message',
        message: 'You have a new message from John Doe.',
        timestamp: DateTime.now(),
      ),
      NotifCardData(
        title: 'Meeting Reminder',
        message: 'Your meeting with the team starts in 15 minutes.',
        timestamp: DateTime.now().subtract(Duration(minutes: 30)),
      ),
      // Add more notifications as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: Column(
          children: [
          PostCardList(postCardData: postCards),
          NotificationListView(notifCardData: notificationsList), 
          ],
        ),
      ),
    );
  }
}
