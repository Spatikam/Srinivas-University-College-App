import 'package:flutter/material.dart';
import 'package:rip_college_app/screens/views/base_screen/home_screen.dart';
import 'package:rip_college_app/screens/views/base_screen/photo_gallery.dart';
import 'package:rip_college_app/screens/widget_common/appbar.dart';
import 'package:rip_college_app/screens/widget_common/navbar.dart';
import 'package:rip_college_app/screens/widget_common/side_panel.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with ChangeNotifier {
  int _currentIndex = 0;

  List<String> imageUrls = [
    'assets/images/image.png',
    'assets/images/image.png'
  // ... more image URLs
  ];


  void _handleCurrentIndex(int value) {
    setState(() {
      _currentIndex = value;
    });
  }

  //Navigation Bar Categories
  final List<Widget> _screens = [
    const HomeScreen(),
    Center(child: Text("Search Screen", style: TextStyle(fontSize: 20))),
    PhotoGallery(imagePaths: [
    'assets/images/image.png',
    'assets/images/image1.jpg',
    'assets/images/image.png',
    'assets/images/image1.jpg',
    'assets/images/image.png',
    'assets/images/image.png',
    'assets/images/image.png',
    'assets/images/image.png'
    // ... more image URLs
    ],),
    Center(child: Text("Calendar Screen", style: TextStyle(fontSize: 20))),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      endDrawer: const CustomEndDrawer(),
      // Rest of your Scaffold content
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: _screens[_currentIndex],
      ),
      extendBody: true,
      bottomNavigationBar: DynamicNavigationBar(
          onValueChanged: _handleCurrentIndex), //BottomNavBarRaisedInsetFb1()
    );
  }
}
