import 'package:flutter/material.dart';
import 'package:rip_college_app/screens/views/home_screen/home_page.dart';  // Ensure MainPage is correctly imported

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to MainPage after a 5-second delay
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,  // Adapts to light/dark theme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the logo image at the top
            Image.asset(
              'assets/icons/splash-logo.png',  // Path to your image file
              width: 200,  // Set the desired width
              height: 200,  // Set the desired height
            ),
            SizedBox(height: 20),  // Space between logo and app name
            // App Name
            Text(
              'UniVerse Srinivas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),  // Space between app name and version
            // Version Number
            Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 40),  // Space before university name
            // University Name
            Text(
              'SRINIVAS UNIVERSITY',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
