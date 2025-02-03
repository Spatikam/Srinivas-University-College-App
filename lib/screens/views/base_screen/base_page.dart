import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rip_college_app/screens/views/base_screen/calendar_screen.dart';
import 'package:rip_college_app/screens/views/base_screen/explore_page.dart';
import 'package:rip_college_app/screens/views/base_screen/home_screen.dart';
import 'package:rip_college_app/screens/views/base_screen/photo_gallery.dart';
import 'package:rip_college_app/screens/widget_common/appbar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with ChangeNotifier {
  int _currentIndex = 0;
  final _controller = PageController(initialPage: 0);
  bool change_page = true;
  List<String> imageUrls = [
    'assets/images/image.png',
    'assets/images/image.png'
    // ... more image URLs
  ];

  @override
  Widget build(BuildContext context) {
    double height = 56;
    final primaryColor = Color(0xFF658CC2);
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex == 0) {
          // If the current screen is the Home page, allow the app to close
          return true; // Allow the back button to close the app
        } else {
          // If the user is not on the Home page, navigate to the previous screen
          _controller.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          return false; // Prevent the app from closing
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(collegeName: "Engineering",),
        // Rest of your Scaffold content
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          //child: _screens[_currentIndex],
          child: PageView(
            controller: _controller,
            onPageChanged: (value) {
              setState(() {
                if (change_page) {
                  _currentIndex = value;
                } else if (_currentIndex == value) change_page = true;
              });
            },
            children: [
              const HomeScreen(),
              ExplorePage(),
              PhotoGallery(
                imagePaths: [
                  'assets/images/image6.jpeg',
                  'assets/images/image7.jpeg',
                  'assets/images/image8.jpeg',
                  'assets/images/image9.jpeg',
                  'assets/images/image1.jpg',
                  'assets/images/image3.jpg',
                  'assets/images/image5.jpg',
                  // ... more image URLs
                ],
              ),
              CalendarScreen(),
            ],
          ),
        ),
        extendBody: true,
        bottomNavigationBar: CurvedNavigationBar(
          index: _currentIndex,
          height: height,
          backgroundColor: Colors.transparent,
          color: primaryColor,
          buttonBackgroundColor: primaryColor,
          animationDuration: const Duration(milliseconds: 300),
          animationCurve: Curves.easeInOut,
          items: [
            PhosphorIcon(PhosphorIcons.house(), size: 30, color: iconColor),
            PhosphorIcon(PhosphorIcons.magnifyingGlass(),
                size: 30, color: iconColor),
            PhosphorIcon(PhosphorIcons.googlePhotosLogo(),
                size: 30, color: iconColor),
            PhosphorIcon(PhosphorIcons.calendar(), size: 30, color: iconColor),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              change_page = false;
            });
            _controller.animateToPage(index,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
        ), //BottomNavBarRaisedInsetFb1()
      ),
    );
  }
}
