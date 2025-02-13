import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rip_college_app/screens/widget_common/image_controls.dart';
import 'package:rip_college_app/screens/widget_common/web_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class EventsPage extends StatefulWidget {
  final String? uuid;
  const EventsPage({super.key, required this.uuid});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final PythonAnywhereService _pythonAnywhereService = PythonAnywhereService();

  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> _articles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
    fetchEvents();
    fetchArticles();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Fetch events from Supabase.
  Future<void> fetchEvents() async {
    setState(() {
      _isLoading = true;
    });

    if (widget.uuid != null) {
      try {
        final data = await Supabase.instance.client.from('Events').select().eq('created_by', widget.uuid as Object).order('Start_date', ascending: true).limit(10);

        _events = List<Map<String, dynamic>>.from(data as List);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching events: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Show event details in a modal bottom sheet.
  void _showEventDetails(BuildContext context, EventCard event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display event image.
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: event.imagePath.startsWith("http") 
                  ? Image.network(event.imagePath, height: 200, width: double.infinity, fit: BoxFit.cover) 
                  : Image.asset(event.imagePath, height: 200, fit: BoxFit.cover),
              ),
              SizedBox(height: 20),
              Text(
                event.title,
                style: GoogleFonts.kanit(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Date: ${event.date}",
                style: GoogleFonts.kanit(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Venue: ${event.venue}",
                style: GoogleFonts.kanit(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Contact: ${event.contact}",
                style: GoogleFonts.kanit(fontSize: 16),
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    event.description,
                    style: GoogleFonts.kanit(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewPage(url: "https://www.suiet.in/", appbar_display: true))),
                child: Text(
                  "Visit Website",
                  style: GoogleFonts.kanit(fontSize: 16, color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Build the Featured Events list.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            ClipPath(
              clipper: CurvedClipper(),
              child: Container(
                height: _animation.value,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).brightness == Brightness.dark ? Colors.deepOrange.shade700 : Colors.orange,
                      Theme.of(context).brightness == Brightness.dark ? Colors.deepOrange.shade900 : Colors.deepOrange,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  Center(
                    child: Text(
                      "Events Conducted",
                      style: GoogleFonts.kanit(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      AnimatedCategoryCard(title: "Technical", maxCount: 18, color: Colors.blue),
                      AnimatedCategoryCard(title: "Cultural", maxCount: 11, color: Colors.purple),
                      AnimatedCategoryCard(title: "Sports", maxCount: 7, color: Colors.green),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Featured Events Section
                  SectionTitle(
                    title: "Featured Events",
                    onSeeAll: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewPage(url: "https://www.suiet.in/", appbar_display: true))),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _events.length,
                            itemBuilder: (context, index) {
                              final event = _events[index];
                              // Build the full image URL from the stored filename.
                              final imageUrl = (event['Poster_path'] != null && event['Poster_path'].toString().isNotEmpty)
                                  ? _pythonAnywhereService.getImageUrl("suiet", event['Poster_path'])
                                  : "assets/images/default_event.jpg";
                              return GestureDetector(
                                onTap: () => _showEventDetails(
                                    context,
                                    EventCard(
                                      title: event['Name'] ?? "No Title",
                                      date: event['Start_date'] != null ? event['Start_date'].split('T')[0] : "",
                                      venue: event['Venue'] ?? "",
                                      imagePath: imageUrl,
                                      description: event['Description'] ?? "",
                                      contact: event['Contact'].toString(),
                                    )),
                                child: EventCard(
                                  title: event['Name'] ?? "No Title",
                                  date: event['Start_date'] != null ? event['Start_date'].split('T')[0] : "",
                                  venue: event['Venue'] ?? "",
                                  imagePath: imageUrl,
                                  description: event['Description'] ?? "",
                                  contact: event['Contact'].toString(),
                                ),
                              );
                            },
                          ),
                  ),
                  SizedBox(height: 30),
                  // Popular Articles Section (example using local asset images)
                  SectionTitle(
                    title: "Popular Articles",
                    onSeeAll: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewPage(url: "https://www.suiet.in/", appbar_display: true))),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _articles.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _showArticleDetails(context, _articles[index].map((key, value) => MapEntry(key, value.toString()))),
                        child: _buildArticleCard(
                          imagePath: _pythonAnywhereService.getImageUrl("suiet", _articles[index]['Image_path']), // Match stored field
                          title: _articles[index]['Heading'] ?? 'No Title', // Match stored field
                          author: _articles[index]['Published_by'] ?? 'Unknown Author', // Match stored field
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchArticles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await Supabase.instance.client.from('Articles').select('*').eq('op_id', widget.uuid as Object);
      setState(() {
        _articles = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching articles: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildArticleCard({
    required String imagePath,
    required String title,
    required String author,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
            child: Image.network(
              imagePath,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.kanit(fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    author,
                    style: GoogleFonts.kanit(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showArticleDetails(BuildContext context, Map<String, String> article) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  _pythonAnywhereService.getImageUrl("suiet", article['Image_path']!),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                article['Heading']!,
                style: GoogleFonts.kanit(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Published by: ${article['Published_by']!}",
                style: GoogleFonts.kanit(fontSize: 16),
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    article['Description']!,
                    style: GoogleFonts.kanit(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const SectionTitle({super.key, required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.kanit(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: Text(
            "See All",
            style: GoogleFonts.kanit(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}

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

class AnimatedCategoryCard extends StatefulWidget {
  final String title;
  final int maxCount;
  final Color color;

  const AnimatedCategoryCard({super.key, required this.title, required this.maxCount, required this.color});

  @override
  _AnimatedCategoryCardState createState() => _AnimatedCategoryCardState();
}

class _AnimatedCategoryCardState extends State<AnimatedCategoryCard> {
  int currentCount = 0;

  @override
  void initState() {
    super.initState();
    startCountAnimation();
  }

  void startCountAnimation() async {
    for (int i = 1; i <= widget.maxCount; i++) {
      await Future.delayed(Duration(milliseconds: 150), () {
        if (mounted) {
          setState(() {
            currentCount = i;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(color: widget.color.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(widget.title, style: GoogleFonts.kanit(color: widget.color, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(
              "$currentCount",
              style: GoogleFonts.kanit(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String venue;
  final String imagePath;
  final String description;
  final String contact;
  final bool del_op;
  final VoidCallback? onDelPressed;

  const EventCard({
    super.key,
    required this.title,
    required this.date,
    required this.venue,
    required this.imagePath,
    required this.description,
    required this.contact,
    this.del_op = false,
    this.onDelPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Determine whether to use a network image or an asset image.
    Widget imageWidget;
    if (imagePath.startsWith("http")) {
      imageWidget = Image.network(
        imagePath,
        height: 100,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
      );
    } else {
      imageWidget = Image.asset(
        imagePath,
        height: 100,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    //final primaryColor = Color(0xFF658CC2);
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    //final themeColor = isDarkMode ? Colors.black : Colors.white;

    return Container(
      width: 200,
      margin: EdgeInsets.only(bottom: 10, right: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageWidget,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Column(
                children: [
                  Text(
                    title,
                    style: GoogleFonts.kanit(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Icon(
                    Icons.touch_app,
                    color: iconColor,
                    size: 20,
                  ),
                ],
              ),
              Spacer(),
              if (del_op)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelPressed,
                ),
            ],
          )
        ],
      ),
    );
  }
}
