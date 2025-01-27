import 'package:flutter/material.dart';
import 'package:rip_college_app/screens/views/base_screen/calendar_screen.dart';
import 'package:rip_college_app/screens/views/base_screen/home_screen.dart';
import 'package:rip_college_app/screens/views/base_screen/photo_gallery.dart';
import 'package:rip_college_app/screens/widget_common/appbar.dart';
import 'package:rip_college_app/screens/widget_common/navbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with ChangeNotifier{
  //int _currentIndex = 0;
  final _controller = PageController(initialPage: 0);
  List<String> imageUrls = [
    'assets/images/image.png',
    'assets/images/image.png'
    // ... more image URLs
  ];

  void _handleCurrentIndex(int value) {
    setState(() {
      _controller.animateToPage(value,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    DynamicNavigationBar nav_bar = DynamicNavigationBar(
          onValueChanged: _handleCurrentIndex);
    return Scaffold(
      appBar: CustomAppBar(),
      // Rest of your Scaffold content
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        //child: _screens[_currentIndex],
        child: PageView(
          controller: _controller,
          children: [
            const HomeScreen(),
            Center(
                child: Text("Search Screen", style: TextStyle(fontSize: 20))),
            PhotoGallery(
              imagePaths: [
                'assets/images/image1.jpg',
                'assets/images/image2.jpg',
                'assets/images/image3.jpg',
                'assets/images/image4.jpg',
                'assets/images/image5.jpg',
                // ... more image URLs
              ],
            ),
            CalendarScreen(),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: nav_bar, //BottomNavBarRaisedInsetFb1()
    );
  }
}
