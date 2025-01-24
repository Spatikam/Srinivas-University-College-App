import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class DynamicNavigationBar extends StatefulWidget {
  @override
  State<DynamicNavigationBar> createState() => _DynamicNavigationBarState();
}

class _DynamicNavigationBarState extends State<DynamicNavigationBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    double height = 56;

    final primaryColor = const Color.fromARGB(255, 14, 37, 137);
    const secondaryColor = Colors.black;
    final backgroundColor = Colors.white;

    return CurvedNavigationBar(
      index: _currentIndex,
      height: height + 10,
      backgroundColor: Colors.transparent,
      color: primaryColor,
      buttonBackgroundColor: backgroundColor,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
      items: const [
        Icon(Icons.home_outlined, size: 30, color: secondaryColor),
        Icon(Icons.search_outlined, size: 30, color: secondaryColor),
        Icon(Icons.local_grocery_store_outlined, size: 30, color: secondaryColor),
        Icon(Icons.date_range_outlined, size: 30, color: secondaryColor),
      ],
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
