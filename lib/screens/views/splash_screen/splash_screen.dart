import 'package:flutter/material.dart';
import 'package:rip_college_app/screens/views/main_screen/homepage.dart';
import 'package:shimmer/shimmer.dart';
//import 'navigation.dart'; // Import your navigation screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to Navigation screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shimmer effect for the logo
            Shimmer.fromColors(
              baseColor: Colors.yellow.shade600,
              highlightColor: Colors.white,
              child: Image.asset(
                'assets/icons/splash-logo.png', // Replace with your image path
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            // Text below the logo
            Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.yellow.shade600,
              child: const Text(
                "Srinivas University",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}