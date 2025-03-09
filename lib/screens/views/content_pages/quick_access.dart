import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';

class QuickAccessPage extends StatefulWidget {
  final String collegeName;


  const QuickAccessPage({super.key, required this.collegeName});

  @override
  _QuickAccessPageState createState() => _QuickAccessPageState();
}

class _QuickAccessPageState extends State<QuickAccessPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final String webflow_no = '+91 9876543210';

  final Map<String, List> access_values = {
    'Engineering & Technology': [
      '+91 1234567890', // call support
      '+91 9876543210', // Emergency
      '+91 5555555555', // Help Desk
      '+91 6366410493', // Office
      '0824 2412382', // Admissions
      'https://t.me/+VcEa0Iz-mICpQZ_T', // Telegram
      'https://www.instagram.com/suiet_mukka?igsh=MTVrcTJpNW5uZnBxNA==', // Insta
      'https://www.linkedin.com/company/srinivasuniversity/?originalSubdomain=in' // LindkedIn
    ],
    'Management & Commerce': [
      '+91 ', // call support
      '+91 ', // Emergency
      '+91 ', // Help Desk
      '+91 ', // Office
      ' ', // Admissions
      '', // Telegram
      '', // Insta
      '' // LindkedIn
    ],
    'Computer and Information science': [
      '+91 ', // call support
      '+91 ', // Emergency
      '+91 ', // Help Desk
      '+91 ', // Office
      ' ', // Admissions
      '', // Telegram
      '', // Insta
      '' // LindkedIn
    ],
    'Hotel Management & Tourism': [
      '+91 ', // call support
      '+91 ', // Emergency
      '+91 ', // Help Desk
      '+91 ', // Office
      ' ', // Admissions
      '', // Telegram
      '', // Insta
      '' // LindkedIn
    ],
    'Physiotherapy': [
      '+91 ', // call support
      '+91 ', // Emergency
      '+91 ', // Help Desk
      '+91 ', // Office
      ' ', // Admissions
      '', // Telegram
      '', // Insta
      '' // LindkedIn
    ],
    'Allied Health Sciences': [
      '+91 ', // call support
      '+91 ', // Emergency
      '+91 ', // Help Desk
      '+91 ', // Office
      ' ', // Admissions
      '', // Telegram
      '', // Insta
      '' // LindkedIn
    ],
    'Social Sciences & Humanities': [
      '+91 ', // call support
      '+91 ', // Emergency
      '+91 ', // Help Desk
      '+91 ', // Office
      ' ', // Admissions
      '', // Telegram
      '', // Insta
      '' // LindkedIn
    ],
    'Education(IED)': [
      '+91 ', // call support
      '+91 ', // Emergency
      '+91 ', // Help Desk
      '+91 ', // Office
      ' ', // Admissions
      '', // Telegram
      '', // Insta
      '' // LindkedIn
    ],
    'Nursing Science': [
      '+91 ', // call support
      '+91 ', // Emergency
      '+91 ', // Help Desk
      '+91 ', // Office
      ' ', // Admissions
      '', // Telegram
      '', // Insta
      '' // LindkedIn
    ],
    'Aviation Studies': [
      '+91 ', // call support
      '+91 ', // Emergency
      '+91 ', // Help Desk
      '+91 ', // Office
      ' ', // Admissions
      '', // Telegram
      '', // Insta
      '' // LindkedIn
    ],
    'Port Shipping and Logistics': [
      '+91 ', // call support
      '+91 ', // Emergency
      '+91 ', // Help Desk
      '+91 ', // Office
      ' ', // Admissions
      '', // Telegram
      '', // Insta
      '' // LindkedIn
    ],
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 800, end: 250).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to make a phone call
  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: "tel", path: phoneNumber);
    if (!await launchUrl(phoneUri)) {
      throw 'Could not launch $phoneUri';
    }
  }

// Function to open social media links
  void _launchSocialMedia(String url) async {
    final Uri socialUri = Uri.parse(url);
    if (!await launchUrl(socialUri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $socialUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    //final primaryColor = Color(0xFF658CC2);
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    //final themeColor = isDarkMode ? Colors.black : Colors.white;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background gradient with animation
            ClipPath(
              clipper: CurvedClipper(),
              child: Container(
                height: _animation.value,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).brightness == Brightness.dark ? Colors.green.shade700 : Colors.lightGreen,
                      Theme.of(context).brightness == Brightness.dark ? Colors.green.shade900 : Colors.green,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Center(
                    child: Text(
                      "Quick Access",
                      style: GoogleFonts.kanit(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Three square box widgets for Quick Access
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildQuickAccessCard(
                        context,
                        icon: PhosphorIcons.phoneCall(),
                        label: "Call Support",
                        phoneNumber: access_values[widget.collegeName]![0],
                      ),
                      _buildQuickAccessCard(
                        context,
                        icon: PhosphorIcons.warningCircle(),
                        label: "Emergency",
                        phoneNumber: access_values[widget.collegeName]![1],
                      ),
                      _buildQuickAccessCard(
                        context,
                        icon: PhosphorIcons.lifebuoy(),
                        label: "Help Desk",
                        phoneNumber: access_values[widget.collegeName]![2],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // College Contacts Section
                  Text(
                    "College Contacts",
                    style: GoogleFonts.kanit(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildCollegeContactCard(
                    context,
                    icon: PhosphorIcons.buildingOffice(),
                    label: "Office",
                    phoneNumber: access_values[widget.collegeName]![3],
                  ),
                  const SizedBox(height: 10),
                  _buildCollegeContactCard(
                    context,
                    icon: PhosphorIcons.laptop(),
                    label: "Admissions",
                    phoneNumber: access_values[widget.collegeName]![4],
                  ),
                  const SizedBox(height: 10),
                  _buildCollegeContactCard(
                    context,
                    icon: PhosphorIcons.graduationCap(),
                    label: "Webflow",
                    phoneNumber: webflow_no,
                  ),
                  const SizedBox(height: 30),
                  // Social Media Card
                  Text(
                    "Connect with Us",
                    style: GoogleFonts.kanit(fontSize: 18, fontWeight: FontWeight.bold, color: iconColor),
                  ),
                  const SizedBox(height: 10),
                  _buildSocialMediaCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Quick Access Card
  Widget _buildQuickAccessCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String phoneNumber,
  }) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    //final primaryColor = Color(0xFF658CC2);
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    //final themeColor = isDarkMode ? Colors.black : Colors.white;
    return GestureDetector(
      onTap: () => _makePhoneCall(phoneNumber),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: iconColor),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.kanit(fontSize: 12, fontWeight: FontWeight.bold, color: iconColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget for College Contact Card
  Widget _buildCollegeContactCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String phoneNumber,
  }) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    //final primaryColor = Color(0xFF658CC2);
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    //final themeColor = isDarkMode ? Colors.black : Colors.white;
    return GestureDetector(
      onTap: () => _makePhoneCall(phoneNumber),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: iconColor),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.kanit(fontSize: 16, fontWeight: FontWeight.bold, color: iconColor),
            ),
            const Spacer(),
            Text(
              phoneNumber,
              style: GoogleFonts.kanit(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Social Media Card
  Widget _buildSocialMediaCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialMediaIcon(
                context,
                lottieAsset: "assets/icons/telegram.json",
                onTap: () => _launchSocialMedia(access_values[widget.collegeName]![5]),
              ),
              _buildSocialMediaIcon(
                context,
                lottieAsset: "assets/icons/insta.json",
                onTap: () => _launchSocialMedia(access_values[widget.collegeName]![6]),
              ),
              _buildSocialMediaIcon(
                context,
                lottieAsset: "assets/icons/linkedin.json",
                onTap: (() => _launchSocialMedia(access_values[widget.collegeName]![7])),
              )
            ],
          ),
        ],
      ),
    );
  }

  // Widget for Social Media Icon with Lottie Animation
  Widget _buildSocialMediaIcon(
    BuildContext context, {
    required String lottieAsset,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Lottie.asset(
        lottieAsset,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
    );
  }
}

// Custom clipper for the curved background
class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
