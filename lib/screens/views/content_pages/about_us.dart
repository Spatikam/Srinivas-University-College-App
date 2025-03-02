import 'dart:async';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isImageSticky = false;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        setState(() {
          _isImageSticky = _scrollController.offset > 100;
        });
      }
    });
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    //final primaryColor = Color(0xFF658CC2);
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final themeColor = isDarkMode ? Colors.grey[850] : Colors.white;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Image instead of video
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/campus.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Explore the",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: iconColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "world with us",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Join Our Journey",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 20),
                      LinearProgressIndicator(
                        value: 0.36,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "36 Years",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Client about",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: iconColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Our mission is to provide exceptional travel experiences that inspire and connect people with the world. We believe in creating memorable journeys that leave a lasting impact.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 40),
                      // Chancellor Card (Moved to the top)
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: themeColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                'assets/images/chanchellor.png', // Chancellor's image
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Raghavendra Rao",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "The Chancellor is the head of the university, responsible for overseeing its academic and administrative functions. With a vision for excellence, the Chancellor ensures the institution remains a leader in education and innovation.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Chancellor’s Message",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "As the Chancellor of Srinivas University and Group of Colleges, I take immense pride in fostering innovation and excellence among our students. Our institution has always been committed to providing a platform where young minds can explore, create, and excel. I am delighted to witness our students develop this remarkable Faculty Availability App, a project entirely conceptualized, designed, and built by them. This initiative showcases the technical expertise, dedication, and problem-solving skills nurtured within our university.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      // Developer Card (Moved below Chancellor Card)
                      GestureDetector(
                        onTap: () => _showAboutDevelopers(context, 'assets/images/about.jpg'),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: themeColor,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  'assets/images/spatikam.jpeg', // Developer team image
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "SPATIKAM",
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: iconColor),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Our talented team of developers has worked tirelessly to bring this project to life. Click to learn more about them!,is a dynamic and innovative community club at Srinivas University, dedicated to fostering a collaborative environment for software engineering enthusiasts. The club brings together students with a passion for coding, technology, and real-world problem-solving. At Webflow, students are provided with the opportunity to work on cutting-edge, real-time projects that simulate industry experiences.The club offers extensive support and guidance from experienced faculty members who mentor students through every phase of project development. These teachers bring their expertise to the table, ensuring that each project is designed and executed according to professional standards. They encourage students to explore various technologies, tools, and frameworks,  .",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sticky Image Behavior
          Positioned(
            top: _isImageSticky ? 100 + (_scrollController.hasClients ? _scrollController.offset : 0) : 200 + (_scrollController.hasClients ? _scrollController.offset : 0),
            right: 20,
            child: GestureDetector(
              onTap: () => _showAboutDevelopers(context, 'assets/images/about.jpg'),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: _isImageSticky ? 100 : 100,
                width: _isImageSticky ? 100 : 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage('assets/images/about.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showAboutDevelopers(BuildContext context, String imagePath) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image at the top (25% height)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
              ),
              SizedBox(height: 20),

              // Team Name
              Text(
                "SPATIKAM",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              // Team Members & Roles
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTeamMember("A K Kavan", "FrontEnd Expert & Backend Integration"),
                  _buildTeamMember("Evan M Anto", "Project Manager & Core Developer"),
                  _buildTeamMember("Harishankar P", "Backend Designer & Developer"),
                  _buildTeamMember("Harshith", "Researcher"),
                  _buildTeamMember("Shreya Rao", "Backend Designer & Developer"),
                  _buildTeamMember("Shivanandu", "Figma Designer"),
                  _buildTeamMember("Sumant Bhat", "UI/UX, Frontend Expert & Marketing Manager"),
                ],
              ),
              SizedBox(height: 20),

              // Social Media Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(PhosphorIcons.instagramLogo(), "https://instagram.com"),
                  SizedBox(width: 20),
                  _buildSocialIcon(PhosphorIcons.googlePlayLogo(), "https://play.google.com"),
                  SizedBox(width: 20),
                  _buildSocialIcon(PhosphorIcons.linkedinLogo(), "https://linkedin.com"),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Helper function for team members
Widget _buildTeamMember(String name, String role) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Text(
      "$name - $role",
      style: TextStyle(fontSize: 16, color: Colors.black87),
    ),
  );
}

// Helper function for social media icons
Widget _buildSocialIcon(IconData icon, String url) {
  return InkWell(
    onTap: () async {
      if (await canLaunch(url)) {
        await launch(url);
      }
    },
    child: Icon(icon, size: 30, color: Colors.blueAccent),
  );
}
