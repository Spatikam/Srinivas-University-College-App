import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const PostCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 34, 34, 34),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Changes position of shadow
          ),
        ],
      ),
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Image
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
            child: Image.asset(
              imagePath,
              height: 180.0,
              fit: BoxFit.cover,
            ),
          ),
          // Title
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Description
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              description,
              style: TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}