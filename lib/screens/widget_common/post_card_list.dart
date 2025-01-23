import 'package:flutter/material.dart';
import 'package:rip_college_app/screens/widget_common/post_card.dart';

class PostCardData {
  final String imagePath;
  final String title;
  final String description;

  PostCardData({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

class PostCardList extends StatelessWidget {
  final List<PostCardData> postCardData;

  const PostCardList({Key? key, required this.postCardData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: postCardData.map((data) {
          return PostCard(
            imagePath: data.imagePath,
            title: data.title,
            description: data.description,
          );
        }).toList(),
      ),
    );
  }
}