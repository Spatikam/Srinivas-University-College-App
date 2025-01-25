import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = const Color(0xFF658CC2);
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 36, // Smaller height for the circle
                width: 36, // Smaller width for the circle
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/icons/app-icon.png', // Add your logo here
                    fit: BoxFit
                        .cover, // Ensures the image fits perfectly in the circle
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Srinivas University',
                style: GoogleFonts.kanit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon:  PhosphorIcon(
                    PhosphorIcons.dotsThreeOutline(), // Phosphor menu icon
                    color: iconColor,
                    size: 28, // Adjust size if needed
                  ),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
