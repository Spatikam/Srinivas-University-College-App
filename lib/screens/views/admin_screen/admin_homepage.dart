import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:rip_college_app/screens/views/admin_screen/admin_image.dart';
import 'package:rip_college_app/screens/views/admin_screen/admin_placement.dart';
import 'package:rip_college_app/screens/views/admin_screen/admin_events.dart';
import 'package:rip_college_app/screens/widget_common/appbar.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String selectedOption = "Event";
  
  final Map<String, Widget> optionWidgets = {
    "Event": ProfilePage(),
    "Article": Center(child: Text("Article Content", style: TextStyle(fontSize: 24))),
    "Image": ImagePostPage(),
    "Placement": Placement_Update(),
    "Announcement": Center(child: Text("Announcement Content", style: TextStyle(fontSize: 24))),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: CustomAppBar(collegeName: "Engineering", slide_menu_access: false,),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black45, blurRadius: 10, spreadRadius: 2),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: Colors.black87,
                  value: selectedOption,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  isExpanded: true,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedOption = newValue!;
                    });
                  },
                  items: optionWidgets.keys.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(value, style: TextStyle(fontSize: 20)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Expanded(
            child: PageTransitionSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (child, animation, secondaryAnimation) =>
                  FadeThroughTransition(animation: animation, secondaryAnimation: secondaryAnimation, child: child),
              child: optionWidgets[selectedOption],
            ),
          ),
        ],
      ),
    );
  }
}
