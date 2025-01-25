import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DynamicNavigationBar extends StatefulWidget {
  final Function(int) onValueChanged;
  const DynamicNavigationBar({super.key, required this.onValueChanged});

  @override
  State<DynamicNavigationBar> createState() => _DynamicNavigationBarState();
}

class _DynamicNavigationBarState extends State<DynamicNavigationBar> {
  int _currentIndex = 0;

  void _changeCurrentIndex(int x) {
    setState(() {
      _currentIndex = x;
    });
    widget.onValueChanged(_currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    double height = 56;

    final primaryColor = Color(0xFF658CC2);

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    //final themeColor = isDarkMode ? Colors.black : Colors.white;

    return CurvedNavigationBar(
      index: _currentIndex,
      height: height,
      backgroundColor: Colors.transparent,
      color: primaryColor,
      buttonBackgroundColor: primaryColor,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
      items: [
        PhosphorIcon(PhosphorIcons.house(), size: 30, color: iconColor),
        PhosphorIcon(PhosphorIcons.magnifyingGlass(), size: 30, color: iconColor),
        PhosphorIcon(PhosphorIcons.googlePhotosLogo(),
            size: 30, color: iconColor),
        PhosphorIcon(PhosphorIcons.calendar(), size: 30, color: iconColor),
      ],
      onTap: (index) {
        setState(() {
          _changeCurrentIndex(index);
        });
      },
    );
  }
}
