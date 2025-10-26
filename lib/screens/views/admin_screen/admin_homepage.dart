import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:rip_college_app/screens/views/admin_screen/admin_announcement.dart';
import 'package:rip_college_app/screens/views/admin_screen/admin_article.dart';
import 'package:rip_college_app/screens/views/admin_screen/admin_image.dart';
import 'package:rip_college_app/screens/views/admin_screen/admin_placement.dart';
import 'package:rip_college_app/screens/views/admin_screen/admin_events.dart';
import 'package:rip_college_app/screens/widget_common/appbar.dart';

class AdminPage extends StatefulWidget {
  final String uuid;
  const AdminPage({super.key, required this.uuid});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String selectedOption = "Event";

  late final Map<String, Widget> optionWidgets = {
    "Event": ProfilePage(
      uuid: widget.uuid,
    ),
    "Article": ArticleUpload(
      uuid: widget.uuid,
    ),
    "Image": ImagePostPage(
      uuid: widget.uuid,
    ),
    "Placement": Placement_Update(
      uuid: widget.uuid,
    ),
    "Announcement": AddAnnouncementScreen(
      uuid: widget.uuid,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: CustomAppBar(
        collegeName: "",
        slide_menu_access: false,
      ),
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
              transitionBuilder: (child, animation, secondaryAnimation) => FadeThroughTransition(animation: animation, secondaryAnimation: secondaryAnimation, child: child),
              child: optionWidgets[selectedOption],
            ),
          ),
        ],
      ),
    );
  }
}
