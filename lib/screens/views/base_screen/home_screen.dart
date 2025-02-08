import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false; // Define _isLoading

  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _events = [];

  final List<String> images = [
    //'assets/images/image1.jpg',
    'assets/images/image6.jpg',
    'assets/images/image7.jpg',
    'assets/images/image8.jpg',
    'assets/images/image9.jpg',
  ];

  @override
  void initState() {
    super.initState();
    fetchEvents();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        setState(() {
          _currentPage = (_currentPage + 1) % 3;
        });
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> fetchEvents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('SUIET_Events')
          .select()
          .order('Start_date', ascending: true)
          .limit(10);

      _events = List<Map<String, dynamic>>.from(response); // Direct cast
    } catch (e) {
      print("Supabase error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching events: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    //final primaryColor = Color(0xFF658CC2);
    //final iconColor = isDarkMode ? Colors.white : Colors.black;
    //final themeColor = isDarkMode ? Colors.black : Colors.white;
    return Container(
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    height: 200,
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              Image.asset(
                                images[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Color(0xFF658CC2),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  height: 180,
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Explore Academics, Notices, Feeds\nall in one app',
                    style: GoogleFonts.kanit(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              child: Column(
                children: [
                  _buildSectionTitle('Explore '),
                  const SizedBox(height: 15),
                  _buildGridView(),
                  _buildSectionTitle('Build'),
                  const SizedBox(height: 15),
                  _buildBuildSection(),
                  _buildSectionTitle('Announcements'),
                  _buildAnnouncements(),
                  const SizedBox(height: 56),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Your existing helper functions remain the same here
  Widget _buildSectionTitle(String title) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    //final primaryColor = const Color(0xFF658CC2);
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    //final themeColor = isDarkMode ? Colors.black : Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: GoogleFonts.kanit(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: iconColor,
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        children: [
          _buildSection(
            gradient: LinearGradient(
                colors: [Colors.orange.shade300, Colors.orange.shade100]),
            icon: PhosphorIcons.clock(),
            title: 'Events',
            description: 'All your course syllabus & guide at your fingertips.',
          ),
          _buildSection(
            gradient: LinearGradient(
                colors: [Colors.purple.shade300, Colors.purple.shade100]),
            icon: PhosphorIcons.googlePhotosLogo(),
            title: 'Photo Gallery',
            description: 'Find unit-wise solved question & answers.',
          ),
        ],
      ),
    );
  }

  Widget _buildBuildSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        children: [
          _buildSection(
            gradient: LinearGradient(
                colors: [Colors.blue.shade300, Colors.blue.shade100]),
            icon: PhosphorIcons.buildings(),
            title: 'Infrastructure',
            description: 'Explore labs, libraries, and other facilities.',
          ),
          _buildSection(
            gradient: LinearGradient(
                colors: [Colors.green.shade300, Colors.green.shade100]),
            icon: PhosphorIcons.book(),
            title: 'Curriculum',
            description: 'Detailed curriculum for each course.',
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required Gradient gradient,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return GestureDetector(
      onTap: () => _showPopup(title, description),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PhosphorIcon(icon, size: 32, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.kanit(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: GoogleFonts.kanit(
                fontSize: 13,
                color: Colors.black.withOpacity(0.6),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showPopup(String title, String description) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    //final primaryColor = const Color(0xFF658CC2);
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    //final themeColor = isDarkMode ? Colors.black : Colors.white;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.kanit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: GoogleFonts.kanit(
                  fontSize: 14,
                  color: iconColor.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.kanit(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnnouncements() {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    //final primaryColor = const Color(0xFF658CC2);
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final themeColor = isDarkMode ? Colors.black : Colors.white;

    int? expandedIndex;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: List.generate(_events.length, (index) {
              final event = _events[index];
              final isExpanded = expandedIndex ==
                  index; // Correct comparison for null-safe value

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(bottom: 12),
                padding:
                    isExpanded ? const EdgeInsets.all(16.0) : EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: isExpanded ? Colors.blue.shade50 : themeColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: isExpanded ? 12 : 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () {
                    // Wrap the setState call to ensure safety during the rebuild
                    setState(() {
                      expandedIndex = isExpanded
                          ? null
                          : index; // Toggle between expanded/collapsed
                    });
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(
                      Icons.message_rounded,
                      size: 32,
                      color: Colors.orange.shade300,
                    ),
                    title: Text(
                      event['Name'] ??
                          'Event ${index + 1}', // Safe fallback for event name
                      style: GoogleFonts.kanit(
                        fontSize: isExpanded ? 18 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      event['Description'] ??
                          'No description available.', // Safe fallback for description
                      style: GoogleFonts.kanit(
                        fontSize: 14,
                        color: iconColor.withOpacity(0.6),
                      ),
                    ),
                    trailing: Icon(
                      isExpanded ? Icons.expand_less : Icons.chevron_right,
                      color: Colors.black54,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
