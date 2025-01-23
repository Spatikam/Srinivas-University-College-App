import 'package:flutter/material.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: Center(
        child: PostCardList(postCardData: postCards),
      ),
    );
  }
}
