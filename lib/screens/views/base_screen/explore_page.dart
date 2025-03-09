import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rip_college_app/screens/widget_common/image_controls.dart';
import 'package:rip_college_app/screens/widget_common/web_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExplorePage extends StatefulWidget {
  final String collegeName;
  final String? uuid;

  const ExplorePage({super.key, required this.collegeName, required this.uuid});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<Map<String, dynamic>> _placements = [];
  bool _isLoading = false;
  final PythonAnywhereService _pythonAnywhereService = PythonAnywhereService();

  late String collegeName = widget.collegeName;

  late final Map<String, List> exploreCategories = {
    'Engineering & Technology': [
      {
        'title': 'Courses',
        'icon': PhosphorIcons.bookOpen(),
        'gotoPage': WebViewPage(
          url: "https://www.suiet.in/courses",
          collegeName: widget.collegeName,
        )
      },
      {
        'title': 'Events',
        'icon': PhosphorIcons.calendar(),
        'gotoPage': WebViewPage(
          url: "https://www.suiet.in/event",
          collegeName: widget.collegeName,
        )
      },
      {
        'title': 'News',
        'icon': PhosphorIcons.newspaper(),
        'gotoPage': WebViewPage(
          url: "https://youtube.com/@mediaandpresssrinivasunive4484?si=mJpfo3mlo4Kzo2xz",
          collegeName: widget.collegeName,
        )
      },
      {
        'title': 'Alumnus',
        'icon': PhosphorIcons.users(),
        'gotoPage': WebViewPage(
          url: "https://srinivasuniversity.edu.in/SrinivasUniversity/ALUMNI",
          collegeName: widget.collegeName,
        )
      },
      {
        'title': 'Library',
        'icon': PhosphorIcons.book(),
        'gotoPage': WebViewPage(
          url: "https://srinivasuniversity.edu.in/SrinivasUniversity/Library",
          collegeName: widget.collegeName,
        )
      },
      {
        'title': 'Placements',
        'icon': PhosphorIcons.suitcase(),
        'gotoPage': WebViewPage(
          url: "https://www.suiet.in/",
          collegeName: widget.collegeName,
          appbar_display: true,
        )
      },
    ],
    'Hotel Management & Tourism': [
      {
        'title': 'Courses',
        'icon': PhosphorIcons.bookOpen(),
        'gotoPage': WebViewPage(
          url: "https://srinivasuniversity.edu.in/College-Of-Hotel-Management-And-Tourism/Courses",
          collegeName: widget.collegeName,
        )
      },
      {
        'title': 'Student Life',
        'icon': PhosphorIcons.basketball(),
        'gotoPage': WebViewPage(
          url: "https://srinivasuniversity.edu.in/College-Of-Hotel-Management-And-Tourism/Student-Life-at-Campus",
          collegeName: widget.collegeName,
        )
      },
      {
        'title': 'News',
        'icon': PhosphorIcons.newspaper(),
        'gotoPage': WebViewPage(
          url: "https://srinivasuniversity.edu.in/College-Of-Hotel-Management-And-Tourism/Blog-Category?newsEvents=1",
          collegeName: widget.collegeName,
        )
      },
      {
        'title': 'Alumnus',
        'icon': PhosphorIcons.users(),
        'gotoPage': WebViewPage(
          url: "https://srinivasuniversity.edu.in/SrinivasUniversity/ALUMNI",
          collegeName: widget.collegeName,
        )
      },
      {
        'title': 'Library',
        'icon': PhosphorIcons.book(),
        'gotoPage': WebViewPage(
          url: "https://srinivasuniversity.edu.in/SrinivasUniversity/Library",
          collegeName: widget.collegeName,
        )
      },
      {
        'title': 'Placements',
        'icon': PhosphorIcons.suitcase(),
        'gotoPage': WebViewPage(
          url: "https://srinivasuniversity.edu.in/College-Of-Hotel-Management-And-Tourism/Placement-Info",
          collegeName: widget.collegeName,
          appbar_display: true,
        )
      },
    ],
    'Management & Commerce': [],
    'Computer and Information science': [],
    'Hotel Management': [],
    'Physiotherapy': [],
    'Allied Health Sciences': [],
    'Education(IED)': [],
    'Nursing Science': [],
    'Social Sciences & Humanities': [],
    'Port Shipping and Logistics': []
  };

  late Map<String, List> explore_more = {
    'Engineering & Technology': [
      WebViewPage(
        url: "https://www.suiet.in/gallery/campus-life",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "https://www.suiet.in/",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "https://www.suiet.in/about-us/Institute-Engineering%20&%20Technology",
        collegeName: widget.collegeName,
      ),
    ],
    'Hotel Management & Tourism': [
      WebViewPage(
        url: "https://srinivasuniversity.edu.in/College-Of-Hotel-Management-And-Tourism/Facilities",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "https://srinivasuniversity.edu.in/College-Of-Hotel-Management-And-Tourism/Calendar",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "https://srinivasuniversity.edu.in/College-Of-Hotel-Management-And-Tourism/About-Us",
        collegeName: widget.collegeName,
      ),
    ],
    'Management & Commerce': [
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
    ],
    'Computer Science & Information Science': [
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
    ],
    'Physiotherapy': [
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
    ],
    'Allied Health Sciences': [
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
    ],
    'Social Sciences & Humanities': [
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
    ],
    'Education(IED)': [
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
    ],
    'Nursing Science': [
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
    ],
    'Aviation Studies': [
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
    ],
    'Port Shipping and Logistics': [
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
      WebViewPage(
        url: "",
        collegeName: widget.collegeName,
      ),
    ]
  };

  @override
  void initState() {
    super.initState();
    fetchplacements();
  }

  Future<void> fetchplacements() async {
    setState(() {
      _isLoading = true;
    });
    if (widget.uuid != null) {
      try {
        final response = await Supabase.instance.client.from('Placements').select("*").eq('Uploaded_by', widget.uuid as Object);

        _placements = List<Map<String, dynamic>>.from(response); // Direct cast
      } catch (e) {
        print("Supabase error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error Fetching Placements')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
            style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
          ),
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
        ));
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
      items: _placements.map((placed) {
        return Builder(
          builder: (BuildContext context) {
            return FadeIn(
              duration: const Duration(milliseconds: 800),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(_pythonAnywhereService.getImageUrl("suiet", placed['Link'])), //Image.network(placed['Link'], fit: BoxFit.cover);,
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
                          placed['Name']!,
                          style: GoogleFonts.kanit(
                            color: iconColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Package: ${placed['LPA']!} LPA',
                          style: GoogleFonts.kanit(
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
              style: GoogleFonts.kanit(
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
              itemCount: exploreCategories[collegeName]!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => exploreCategories[collegeName]![index]['gotoPage']),
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
                          exploreCategories[collegeName]![index]['icon'],
                          size: 30,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          exploreCategories[collegeName]![index]['title']!,
                          style: GoogleFonts.kanit(
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
              style: GoogleFonts.kanit(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                ListTile(
                  leading: Icon(FontAwesomeIcons.university, color: Colors.blueAccent),
                  title: Text('Campus', style: GoogleFonts.kanit(fontSize: 14)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => explore_more[collegeName]![0]),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.calendarDays, color: Colors.blueAccent),
                  title: Text('Academic Calendar', style: GoogleFonts.kanit(fontSize: 14)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => explore_more[collegeName]![1]),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.infoCircle, color: Colors.blueAccent),
                  title: Text('About College', style: GoogleFonts.kanit(fontSize: 14)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => explore_more[collegeName]![2]),
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
