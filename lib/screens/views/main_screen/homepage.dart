import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:rip_college_app/screens/views/base_screen/base_page.dart';
import 'package:rip_college_app/screens/widget_common/appbar.dart';
import 'package:rip_college_app/screens/widget_common/web_view.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  final List<String> imageUrls = [
    'assets/images/srinivas.JPG',
    'assets/images/srinivas1.JPG',
    'assets/images/srinivas3.JPG',
  ];

  final List<String> imageDescriptions = [
    'Chancellor’s Speech - A prestigious moment of the institution',
    'Bharatanatyam - Cultural performances showcasing talent',
    'Yaksha - A classical dance form representing culture',
  ];

  final List<String> institutions = [
    'Engineering',
    'Management & Commerce',
    'Computer and Information science',
    'Hotel Management',
    'Interior Design',
    'Physiotherapy',
    'Allied health sciences',
    'Education(IED)',
    'Nursing Science',
    'Aviation Studies',
    'Port,Shipping & Logistics',
    'SIT (valachil)',
    'Pharmacy',
    'SIMSRC (Medical)',
    'Dental Sciences',
    'University of Edinburgh',
  ];

  final List<String> institutionLogos = [
    'assets/images/logo.jpg',
    'assets/images/logo.jpg',
    'assets/images/logo.jpg',
    'assets/images/logo.jpg',
    'assets/images/logo.jpg',
    'assets/images/logo.jpg',
    'assets/images/logo.jpg',
    'assets/images/logo.jpg',
    'assets/images/logo.jpg',
    'assets/images/logo.jpg',
    'assets/images/logo.jpg',
    'assets/images/logo.jpg',
    'assets/images/logo.jpg',
    'assets/images/logo.jpg',
    'assets/images/logo.jpg',
    'assets/images/logo.jpg',
  ];

  final List<Color> institutionColors = [
    Colors.blue.shade100,
    Colors.green.shade100,
    Colors.yellow.shade100,
    Colors.purple.shade100,
    Colors.red.shade100,
    Colors.orange.shade100,
    Colors.teal.shade100,
    Colors.cyan.shade100,
    Colors.indigo.shade100,
    Colors.pink.shade100,
    Colors.amber.shade100,
    Colors.lime.shade100,
    Colors.brown.shade100,
    Colors.blueGrey.shade100,
    Colors.deepPurple.shade100,
    Colors.deepOrange.shade100,
  ];

  List<String> filteredInstitutions = [];
  String customLogoUrl = 'assets/images/logo.jpg';

  final Map<String, String> institutionUrls = {
    'Engineering': 'home.dart', // Link to home.dart for engineering
    'Management & Commerce':
        'https://srinivasuniversity.edu.in/College-Of-Management-And-Commerce',
    'Computer and Information science':
        'https://srinivasuniversity.edu.in/College-BCA-MCA',
    'Hotel Management':
        'https://srinivasuniversity.edu.in/College-Of-Hotel-Management-And-Tourism',
    'Interior Design': 'https://interiordesign.srinivasuniversity.edu.in',
    'Physiotherapy':
        'https://srinivasuniversity.edu.in/Institute-Of-Physiotherapy',
    'Allied health sciences':
        'https://srinivasuniversity.edu.in/College-Of-Allied-Health-Sciences',
    'Education(IED)': 'https://srinivasuniversity.edu.in/College-Of-Education',
    'Nursing Science': 'https://srinivasuniversity.edu.in/College-Of-Nursing',
    'Aviation Studies': 'https://aviation.srinivasuniversity.edu.in',
    'Port,Shipping & Logistics': 'https://shipping.srinivasuniversity.edu.in',
    'SIT (valachil)': 'https://sit.srinivasuniversity.edu.in',
    'Pharmacy': 'https://pharmacy.srinivasuniversity.edu.in',
    'SIMSRC (Medical)': 'https://simsrc.srinivasuniversity.edu.in',
    'Dental Sciences': 'https://dental.srinivasuniversity.edu.in',
    'University of Edinburgh': 'https://www.ed.ac.uk',
  };

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredInstitutions = institutions;
  }

  void _searchInstitutions(String query) {
    setState(() {
      filteredInstitutions = institutions
          .where((institution) =>
              institution.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 220,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
              ),
              items: imageUrls.map((url) {
                int index = imageUrls.indexOf(url);
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(
                          15), // Clip the entire container
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.asset(
                              url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              child: Text(
                                imageDescriptions[index],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Kanit',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _searchInstitutions,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    hintText: 'Search institutions...',
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear(); // Clears the text
                        setState(() {
                          filteredInstitutions = institutions;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: filteredInstitutions.length,
                itemBuilder: (context, index) {
                  final institution = filteredInstitutions[index];

                  return GestureDetector(
                    onTap: () {
                      if (institution == 'Engineering') {
                        // Navigate directly to HomeScreen when "Engineering" is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(),
                          ),
                        );
                      } else {
                        final url = institutionUrls[institution] ??
                            'https://srinivasuniversity.edu.in';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebViewPage(url: url,collegeName: institution,)),
                        );
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color:
                            institutionColors[index % institutionColors.length],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            institutionLogos[index % institutionLogos.length],
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(height: 10),
                          Text(
                            institution,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
