import 'package:flutter/material.dart';
import 'package:rip_college_app/screens/views/main_screen/homepage.dart';
import 'package:shimmer/shimmer.dart';// Make sure the navigation screen is imported correctly
import 'dart:ui';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Fade-in animation for the circle
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 0.6;
      });
    });

    // Navigate to Navigation screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NavigationScreen(),
        ), // Make sure NavigationPage exists
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkTheme ? Colors.black : Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shimmer effect for the "Srinivas University" text
            Shimmer.fromColors(
              baseColor: isDarkTheme ? Colors.white : Colors.black,
              highlightColor:
                  isDarkTheme ? Colors.yellow.shade600 : Colors.yellow.shade600,
              child: const Text(
                "SRINIVAS UNIVERSITY",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Stack to position the blurred circle exactly behind the logo
            Stack(
              alignment: Alignment.center,
              children: [
                // Blurred color circle (fades in)
                AnimatedOpacity(
                  duration: Duration(seconds: 2),
                  opacity: _opacity,
                  child: ClipOval(
                    child: Container(
                      width: 250, // Same width as logo
                      height: 250, // Same height as logo
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(0.6), // 60% opacity
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          color: Colors.blue.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                ),
                // Logo on top
                Shimmer.fromColors(
                  baseColor: isDarkTheme
                      ? Colors.yellow.shade600
                      : Colors.yellow.shade600,
                  highlightColor: isDarkTheme
                      ? Colors.white
                      : const Color.fromARGB(255, 255, 255, 255),
                  child: Image.asset(
                    'assets/icons/splash-logo.png', // Your provided logo
                    width: 200,
                    height: 200,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Shimmer effect for the "SAMAGRA GNANA" text
            Shimmer.fromColors(
              baseColor: isDarkTheme ? Colors.white : Colors.black,
              highlightColor:
                  isDarkTheme ? Colors.yellow.shade600 : Colors.blue.shade600,
              child: const Text(
                "SAMAGRA GNANA",
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
