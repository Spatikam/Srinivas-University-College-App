import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rip_college_app/screens/views/content_pages/event_page.dart';
import 'package:rip_college_app/screens/views/content_pages/quick_access.dart';
import 'package:rip_college_app/screens/widget_common/web_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  final String collegeName;
  String uuid;

  HomeScreen({super.key, required this.collegeName, this.uuid = ""});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false; // Define _isLoading
  late String collegeName;

  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> _announcements = [];

  final Map<String, List<String>> images = {
    'Engineering & Technology': [
      'assets/images/suiet/image1.jpg',
      'assets/images/suiet/image2.jpg',
      'assets/images/suiet/image3.jpg',
      'assets/images/suiet/image4.jpg',
    ],
    'Hotel Management & Tourism': [
      'assets/images/ihmt/image1.png',
      'assets/images/ihmt/image2.png',
      'assets/images/ihmt/image3.jpg',
      'assets/images/ihmt/image4.png',
    ],
    'Management & Commerce': [

    ],
    'Computer and Information science': [
      
    ],
    'Physiotherapy': [
      
    ],
    'Allied Health Sciences': [
      
    ],
    'Education(IED)': [
      
    ],
    'Nursing Science': [
      
    ],
    'Social Sciences & Humanities': [
      
    ],
    'Aviation Studies': [
      
    ]
  };

  Future<void> fetchUserId() async {
    try {
      var response = await Supabase.instance.client.from('Users').select('uuid').eq('College', widget.collegeName).maybeSingle();
      setState(() {
        widget.uuid = response!['uuid'];
      });
      fetchAnnouncements();
    } catch (e) {
      log("Supabase error: $e");
    }
  }

  @override
  void initState() {
    super.initState(); // CHECK THIS!!!!
    if (widget.uuid == "") {
      fetchUserId();
    } else {
      fetchAnnouncements();
    }
    
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
    //collegeName = widget.collegeName;
  }

  Future<void> fetchAnnouncements() async {
    setState(() {
      _isLoading = true;
    });
    if (widget.uuid != "") {
      try {
        var response = await Supabase.instance.client.from('Events').select('*').eq('created_by', widget.uuid as Object).order('Start_date', ascending: true).limit(10);
        setState(() {
          _events = List<Map<String, dynamic>>.from(response); // Direct cast
        });
        response = await Supabase.instance.client.from('Announcements').select('*').eq('owner_id', widget.uuid as Object).order('Created_At', ascending: false).limit(10);
        setState(() {
          _announcements = List<Map<String, dynamic>>.from(response);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error Fetching Events')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
                      itemCount: images[widget.collegeName]!.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            children: [
                              Image.asset(
                                images[widget.collegeName]![index],
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Explore'),
                  const SizedBox(height: 15),
                  _buildGridView(),
                  _buildSectionTitle('Announcements'),
                  const SizedBox(height: 15),
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
    Map<String, List> exploreGoto = {
      'Engineering & Technology': [
        EventsPage(
          uuid: widget.uuid,
        ),
        WebViewPage(
          url: "https://www.suiet.in/gallery-suiet",
          collegeName: widget.collegeName,
          appbar_display: true,
        ),
        WebViewPage(
          collegeName: widget.collegeName,
          url: "https://apply.suiet.in/",
          appbar_display: true,
        ),
        QuickAccessPage(collegeName: widget.collegeName,)
      ],
      'Hotel Management & Tourism': [
        EventsPage(
          uuid: widget.uuid,
        ),
        WebViewPage(
          url: "https://srinivasuniversity.edu.in/College-Of-Hotel-Management-And-Tourism/Student-Life-at-Campus",
          collegeName: widget.collegeName,
          appbar_display: true,
        ),
        WebViewPage(
          collegeName: widget.collegeName,
          url: "https://srinivasuniversity.edu.in/SrinivasUniversity/Admission-Enquiry",
          appbar_display: true,
        ),
        QuickAccessPage(collegeName: widget.collegeName,)
      ],
      'Management & Commerce': [
        EventsPage(
          uuid: widget.uuid,
        ),
        WebViewPage(
          url: "",
          collegeName: widget.collegeName,
          appbar_display: true,
        ),
        WebViewPage(
          collegeName: widget.collegeName,
          url: "",
          appbar_display: true,
        ),
        QuickAccessPage(collegeName: widget.collegeName,)
      ],
      'Computer and Information science': [
        EventsPage(
          uuid: widget.uuid,
        ),
        WebViewPage(
          url: "",
          collegeName: widget.collegeName,
          appbar_display: true,
        ),
        WebViewPage(
          collegeName: widget.collegeName,
          url: "",
          appbar_display: true,
        ),
        QuickAccessPage(collegeName: widget.collegeName,)
      ],
      'Physiotherapy': [
        EventsPage(
          uuid: widget.uuid,
        ),
        WebViewPage(
          url: "",
          collegeName: widget.collegeName,
          appbar_display: true,
        ),
        WebViewPage(
          collegeName: widget.collegeName,
          url: "",
          appbar_display: true,
        ),
        QuickAccessPage(collegeName: widget.collegeName,)
      ],
      'Allied Health Sciences': [
        EventsPage(
          uuid: widget.uuid,
        ),
        WebViewPage(
          url: "",
          collegeName: widget.collegeName,
          appbar_display: true,
        ),
        WebViewPage(
          collegeName: widget.collegeName,
          url: "",
          appbar_display: true,
        ),
        QuickAccessPage(collegeName: widget.collegeName,)
      ],
      'Education(IED)': [
        EventsPage(
          uuid: widget.uuid,
        ),
        WebViewPage(
          url: "",
          collegeName: widget.collegeName,
          appbar_display: true,
        ),
        WebViewPage(
          collegeName: widget.collegeName,
          url: "",
          appbar_display: true,
        ),
        QuickAccessPage(collegeName: widget.collegeName,)
      ],
      'Nursing Science': [
        EventsPage(
          uuid: widget.uuid,
        ),
        WebViewPage(
          url: "",
          collegeName: widget.collegeName,
          appbar_display: true,
        ),
        WebViewPage(
          collegeName: widget.collegeName,
          url: "",
          appbar_display: true,
        ),
        QuickAccessPage(collegeName: widget.collegeName,)
      ],
      'Social Sciences & Humanities': [
        EventsPage(
          uuid: widget.uuid,
        ),
        WebViewPage(
          url: "",
          collegeName: widget.collegeName,
          appbar_display: true,
        ),
        WebViewPage(
          collegeName: widget.collegeName,
          url: "",
          appbar_display: true,
        ),
        QuickAccessPage(collegeName: widget.collegeName,)
      ],
      'Aviation Studies': [
        EventsPage(
          uuid: widget.uuid,
        ),
        WebViewPage(
          url: "",
          collegeName: widget.collegeName,
          appbar_display: true,
        ),
        WebViewPage(
          collegeName: widget.collegeName,
          url: "",
          appbar_display: true,
        ),
        QuickAccessPage(collegeName: widget.collegeName,)
      ]
    };
    final List exploreSection = [
      {
        'title': 'Events',
        'description': 'Check out what\'s happenning here at Srinivas University',
        'icon': PhosphorIcons.clock(),
        'goto': exploreGoto[widget.collegeName]![0],
        'gradient': LinearGradient(colors: [Colors.orange.shade300, Colors.orange.shade100]),
      },
      {
        'title': 'PhotoGallery',
        'description': 'Moments captured in time',
        'icon': PhosphorIcons.googlePhotosLogo(),
        'goto': exploreGoto[widget.collegeName]![1],
        'gradient': LinearGradient(colors: [Colors.purple.shade300, Colors.purple.shade100]),
      },
      {
        'title': 'Admission',
        'description': 'Join Srinivas to unlock your True Potential',
        'icon': PhosphorIcons.buildings(),
        'goto': exploreGoto[widget.collegeName]![2],
        'gradient': LinearGradient(colors: [Colors.blue.shade300, Colors.blue.shade100]),
      },
      {
        'title': 'Quick Access',
        'description': 'Access contacts & our social media handles',
        'icon': PhosphorIcons.gridFour(),
        'goto': exploreGoto[widget.collegeName]![3],
        'gradient': LinearGradient(colors: [Colors.green.shade300, Colors.green.shade100]),
      },
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 16,
        ),
        itemCount: exploreSection.length,
        itemBuilder: (context, index) {
          return _buildSection(
            gradient: exploreSection[index]['gradient'],
            icon: exploreSection[index]['icon'],
            title: exploreSection[index]['title'],
            description: exploreSection[index]['description'],
            index: index,
            goto: exploreSection[index]['goto'],
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required Gradient gradient,
    required IconData icon,
    required String title,
    required String description,
    required index,
    required Widget goto,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => goto),
        );
      },
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

  Widget _buildAnnouncements() {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    //final primaryColor = const Color(0xFF658CC2);
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final themeColor = isDarkMode ? Colors.grey[850] : Colors.white;

    int? expandedEventIndex;
    int? expandedAnnouncementIndex;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: List.generate(_announcements.length, (index) {
                      final announcement = _announcements[index];
                      final isExpanded = expandedAnnouncementIndex == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: isExpanded ? const EdgeInsets.all(10.0) : EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: themeColor,
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
                            setState(() {
                              expandedAnnouncementIndex = isExpanded ? null : index;
                            });
                          },
                          child: ListTile(
                            contentPadding: const EdgeInsets.only(left: 5),
                            leading: Icon(
                              Icons.announcement,
                              size: 32,
                              color: Colors.orange.shade300,
                            ),
                            title: Text(
                              announcement['Name'] ?? 'Announcement ${index + 1}',
                              style: GoogleFonts.poppins(
                                fontSize: isExpanded ? 18 : 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              announcement['Description'] ?? 'No description available.',
                              overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
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

                  //Events Section
                  Column(
                    children: List.generate(_events.length, (index) {
                      final event = _events[index];
                      final isExpanded = expandedEventIndex == index; // Correct comparison for null-safe value

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: isExpanded ? const EdgeInsets.all(10.0) : EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: themeColor,
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
                            setState(() {
                              expandedEventIndex = isExpanded ? null : index; // Toggle between expanded/collapsed
                            });
                          },
                          child: ListTile(
                            contentPadding: const EdgeInsets.only(left: 5),
                            leading: Icon(
                              Icons.message_rounded,
                              size: 32,
                              color: Colors.orange.shade300,
                            ),
                            title: Text(
                              event['Name'] ?? 'Event ${index + 1}', // Safe fallback for event name
                              style: GoogleFonts.kanit(
                                fontSize: isExpanded ? 18 : 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              event['Description'] ?? 'No description available.', // Safe fallback for description
                              overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
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
                ],
              ),
            ));
      },
    );
  }
}
