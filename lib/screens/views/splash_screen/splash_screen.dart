import 'package:flutter/material.dart';
import 'package:rip_college_app/screens/views/base_screen/base_page.dart'; // Ensure MainPage is correctly imported
import 'package:lottie/lottie.dart';

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
    Future.delayed(Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color.fromARGB(255, 100, 141, 197),
        child: Center(
          child: Lottie.asset(
            'assets/animation/splash_screen.json', // Replace with the path to your Lottie JSON file
            fit: BoxFit.cover, // Set to true if you want the animation to loop
          ),
        ),
      ),
    );
  }
}
