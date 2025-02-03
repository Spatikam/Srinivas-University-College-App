import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rip_college_app/screens/widget_common/web_view.dart';

class ExplorePage extends StatelessWidget {
  final List<Map<String, String>> alumniData = [
    {
      'image': 'assets/images/alumni1.png',
      'name': 'John Doe',
      'package': '12 LPA'
    },
    {
      'image': 'assets/images/alumni2.png',
      'name': 'Jane Smith',
      'package': '15 LPA'
    },
    {
      'image': 'assets/images/alumni3.png',
      'name': 'Sam Wilson',
      'package': '10 LPA'
    },
  ];

 String collegeName = "Engineering";

  final List exploreCategories = [
    {'title': 'Courses', 'icon': Icons.school, 'gotoPage': WebViewPage(url: "https://www.suiet.in/courses",collegeName: "Engineering",)},
    {'title': 'Sports', 'icon': Icons.sports_soccer, 'gotoPage': WebViewPage(url: "https://www.suiet.in/",collegeName: "Engineering",)},
    {'title': 'News', 'icon': Icons.newspaper, 'gotoPage': WebViewPage(url: "https://www.suiet.in/",collegeName: "Engineering",)},
    {'title': 'Events', 'icon': Icons.event, 'gotoPage': WebViewPage(url: "https://www.suiet.in/event#",collegeName: "Engineering",)},
    {'title': 'Clubs', 'icon': Icons.group, 'gotoPage': WebViewPage(url: "https://www.suiet.in/",collegeName: "Engineering",)},
    {'title': 'Placements', 'icon': Icons.work, 'gotoPage': WebViewPage(url: "https://www.suiet.in/",collegeName: "Engineering",)},
  ];

  ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    //final primaryColor = Color(0xFF658CC2);
    //final iconColor = isDarkMode ? Colors.white : Colors.black;
    final themeColor = isDarkMode ? Colors.black : Colors.white;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Explore',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          backgroundColor: themeColor,
          elevation: 0,
        ),
        body: Container(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAlumniCarousel(context),
                const SizedBox(height: 20),
                _buildExploreCategories(context),
                const SizedBox(height: 20),
                _buildMoreExploreOptions(context),
                const SizedBox(height: 56),
              ],
            ),
          ),
        )
    );
  }

  Widget _buildAlumniCarousel(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    //final primaryColor = Color(0xFF658CC2);
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final themeColor = isDarkMode ? Colors.black : Colors.white;
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        viewportFraction: 0.8,
      ),
      items: alumniData.map((alumnus) {
        return Builder(
          builder: (BuildContext context) {
            return FadeIn(
              duration: const Duration(milliseconds: 800),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(alumnus['image']!),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: themeColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          alumnus['name']!,
                          style: GoogleFonts.poppins(
                            color: iconColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Package: ${alumnus['package']!}',
                          style: GoogleFonts.poppins(
                            color: iconColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildExploreCategories(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FadeInUp(
        duration: const Duration(milliseconds: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Explore Categories',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: exploreCategories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {   
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => exploreCategories[index]['gotoPage']),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          exploreCategories[index]['icon'],
                          size: 30,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          exploreCategories[index]['title']!,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreExploreOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FadeInUp(
        duration: const Duration(milliseconds: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'More to Explore',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                ListTile(
                  leading: Icon(FontAwesomeIcons.university,
                      color: Colors.blueAccent),
                  title: Text('Campus Tour',
                      style: GoogleFonts.poppins(fontSize: 14)),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.calendarDays,
                      color: Colors.blueAccent),
                  title: Text('Academic Calendar',
                      style: GoogleFonts.poppins(fontSize: 14)),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.infoCircle,
                      color: Colors.blueAccent),
                  title: Text('About College',
                      style: GoogleFonts.poppins(fontSize: 14)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WebViewPage(
                                url: "https://www.suiet.in/about-us/Institute-Engineering%20&%20Technology",
                                collegeName: "Engineering",
                              )),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
