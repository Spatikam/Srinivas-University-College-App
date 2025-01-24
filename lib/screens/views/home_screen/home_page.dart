import 'package:flutter/material.dart';
import 'package:rip_college_app/screens/widget_common/appbar.dart';
import 'package:rip_college_app/screens/widget_common/navbar.dart';
import 'package:rip_college_app/screens/widget_common/side_panel.dart';
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

  //MyHomePage({Key? key, required this.title}) : super(key: key);
class _MyHomePageState extends State<MyHomePage> {
  
  int _currentIndex = 0;

  //Navigation Bar Categories
  final List<Widget> _screens = [
    Center(child: Text("Home Screen", style: TextStyle(fontSize: 20))),
    Center(child: Text("Search Screen", style: TextStyle(fontSize: 20))),
    Center(child: Text("Cart Screen", style: TextStyle(fontSize: 20))),
    Center(child: Text("Calendar Screen", style: TextStyle(fontSize: 20))),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appTitle: 'SU Connect',
      ),
      endDrawer: const CustomEndDrawer(),
      // Rest of your Scaffold content
      body:AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex],
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
      ),
      extendBody: true,
      bottomNavigationBar: DynamicNavigationBar(), //BottomNavBarRaisedInsetFb1()
    );
  }
}