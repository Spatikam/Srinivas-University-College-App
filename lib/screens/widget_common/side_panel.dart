import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rip_college_app/main.dart';
import 'package:rip_college_app/screens/views/login_screen/login_page.dart';

class CustomEndDrawer extends StatelessWidget {
  const CustomEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    const primaryColor = const Color(0xFF658CC2);
    const secondaryColor = Colors.black;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Row(
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
              Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Srinivas University',
                        style: GoogleFonts.kanit(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: secondaryColor,
                        ),
                      ),
                      Text(
                        'Engineering',
                        style: GoogleFonts.kanit(
                          fontSize: 16, // Slightly smaller font for "Engineering"
                          fontWeight: FontWeight.w500,
                          color: secondaryColor,
                        ),
                      ),
                    ],
                  ),
            ],
          ),
        ],
      ),
          ),
          ListTile(
            title: const Text('Login'),
            onTap: () {
              // Navigate to Settings screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Light/Dark Mode'),
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark, // Replace with your theme state
              onChanged: (value) {
                themeProvider.toggleTheme(value);
              },
            ),
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              // Navigate to Settings screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('About'),
            onTap: () {
              // Navigate to About screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Placeholder screens for Settings and About
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Text('Settings Screen'),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: const Center(
        child: Text('About Screen'),
      ),
    );
  }
}
