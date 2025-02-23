import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rip_college_app/screens/views/base_screen/calendar_screen.dart';
import 'package:rip_college_app/screens/views/base_screen/explore_page.dart';
import 'package:rip_college_app/screens/views/base_screen/home_screen.dart';
import 'package:rip_college_app/screens/views/base_screen/photo_gallery.dart';
//import 'package:rip_college_app/screens/views/base_screen/photo_gallery.dart';
import 'package:rip_college_app/screens/widget_common/appbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyHomePage extends StatefulWidget {
  final String collegeName;

  const MyHomePage({super.key, required this.collegeName});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with ChangeNotifier {
  int _currentIndex = 0;
  final _controller = PageController(initialPage: 0);
  bool change_page = true;
  String uuid="";

  Future<void> fetchUserId() async {
    try {
      var response = await Supabase.instance.client.from('Users').select('uuid').eq('College', widget.collegeName).maybeSingle();
      setState(() {
        uuid = response!['uuid'];
      });
    } catch (e) {
      print("Supabase error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching uuid: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  @override
  Widget build(BuildContext context) {
    double height = 56;
    final primaryColor = Colors.blue.shade700;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    //final iconColor = isDarkMode ? Colors.white : Colors.black;
    final themeColor = isDarkMode ? Colors.black : Colors.white;

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
          //Navigator.pop(context);
          return false; // Prevent the app from closing
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          collegeName: widget.collegeName,
        ),
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
              HomeScreen(
                collegeName: widget.collegeName,
                uuid: uuid,
              ),
              ExplorePage(
                collegeName: widget.collegeName,
                uuid: uuid,
              ),
              PhotoGallery(
                collegeName: widget.collegeName,
                uuid: uuid,
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
            PhosphorIcon(PhosphorIcons.house(), size: 30, color: themeColor),
            PhosphorIcon(PhosphorIcons.magnifyingGlass(), size: 30, color: themeColor),
            PhosphorIcon(PhosphorIcons.googlePhotosLogo(), size: 30, color: themeColor),
            PhosphorIcon(PhosphorIcons.calendar(), size: 30, color: themeColor),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              change_page = false;
            });
            _controller.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
        ), //BottomNavBarRaisedInsetFb1()
      ),
    );
  }
}
