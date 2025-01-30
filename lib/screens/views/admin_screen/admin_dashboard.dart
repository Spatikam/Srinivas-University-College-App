import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:rip_college_app/screens/views/admin_screen/admin_image.dart';

class AdminDashboard extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {'title': 'Image', 'icon': Icons.image, 'gotopage': () => ImagePostPage()},
    {'title': 'Event', 'icon': Icons.event, 'gotopage': () => ImagePostPage()},
    {'title': 'Article', 'icon': Icons.article_rounded, 'gotopage': () => ImagePostPage()},
    {'title': 'Placement', 'icon': Icons.work, 'gotopage': () => ImagePostPage()},
    {'title': 'Announcement Upload', 'icon': Icons.announcement, 'gotopage': () => ImagePostPage()},
  ];

  final List<Map<String, dynamic>> deleteCategories = [
    {'title': 'Image', 'icon': Icons.delete, 'gotopage': () => ImagePostPage()},
    {'title': 'Event', 'icon': Icons.delete, 'gotopage': () => ImagePostPage()},
    {'title': 'Article', 'icon': Icons.delete, 'gotopage': () => ImagePostPage()},
    {'title': 'Placement', 'icon': Icons.delete, 'gotopage': () => ImagePostPage()},
    {'title': 'Announcement', 'icon': Icons.delete, 'gotopage': () => ImagePostPage()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderAnimation(),
            const SizedBox(height: 30),
            _buildCategorySection('Upload Category', categories),
            const SizedBox(height: 30),
            _buildCategorySection('Delete Category', deleteCategories),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderAnimation() {
    return Center(
      child: FadeInDown(
        duration: const Duration(milliseconds: 800),
        child: Column(
          children: [
            Text(
              'Welcome, Admin!',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(String title, List<Map<String, dynamic>> items) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              return _buildCategoryButton(
                title: items[index]['title'],
                icon: items[index]['icon'],
                gotopage: items[index]['gotopage'], // Fixed function reference
                context: context,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton({
    required String title,
    required IconData icon,
    required Widget Function() gotopage,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => gotopage()),
        );
      },
      child: FlipInY(
        duration: const Duration(milliseconds: 700),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.7),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 1,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.purple[200]),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
