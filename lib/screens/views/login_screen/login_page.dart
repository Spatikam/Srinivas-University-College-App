import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rip_college_app/screens/widget_common/appbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _offsetAnimation;

  bool _isAdmin = true; 

  String? _selectedCollege;
  String? _selectedBranch;

  final List<String> _colleges = ['College A', 'College B', 'College C'];
  final List<String> _branches = ['CSE', 'ECE', 'ME', 'CE'];

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeInOut));

    _offsetAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Color(0xFF658CC2);
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final themeColor = isDarkMode ? Colors.black : Colors.white;
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: 
          ScaleTransition(
          scale: _scaleAnimation,
          child: SlideTransition(
            position: _offsetAnimation,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isAdmin = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: _isAdmin
                                  ? primaryColor
                                  : themeColor,
                            ),
                            child: Text(
                              'Admin',
                              style: TextStyle(
                                color: iconColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isAdmin = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: !_isAdmin
                                  ? primaryColor
                                  : themeColor,
                            ),
                            child: Text(
                              'Student',
                              style: TextStyle(
                                color: iconColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    if (_isAdmin)
                      Column(
                        children: [
                          TextField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () {
                              // Admin login logic here
                              if (_usernameController.text.isNotEmpty &&
                                  _passwordController.text.isNotEmpty) {
                                // Navigate to admin dashboard
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: const AdminDashboard(),
                                    duration: const Duration(milliseconds: 500),
                                  ),
                                );
                              } else {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter username and password'),
                                  ),
                                );
                              }
                            },
                            child: const Text('Login'),
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: _selectedCollege,
                            onChanged: (value) {
                              setState(() {
                                _selectedCollege = value;
                              });
                            },
                            items: _colleges.map((college) {
                              return DropdownMenuItem<String>(
                                value: college,
                                child: Text(college),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              labelText: 'Select College',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          DropdownButtonFormField<String>(
                            value: _selectedBranch,
                            onChanged: (value) {
                              setState(() {
                                _selectedBranch = value;
                              });
                            },
                            items: _branches.map((branch) {
                              return DropdownMenuItem<String>(
                                value: branch,
                                child: Text(branch),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              labelText: 'Select Branch',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () {
                              // Student login logic here
                              if (_selectedCollege != null &&
                                  _selectedBranch != null) {
                                // Navigate to student dashboard
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.fade,
                                    child: const StudentDashboard(),
                                    duration: const Duration(milliseconds: 500),
                                  ),
                                );
                              } else {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Please select college and branch'),
                                  ),
                                );
                              }
                            },
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          
        ),
      ),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: const Center(
        child: Text('Welcome, Admin!'),
      ),
    );
  }
}

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
      ),
      body: const Center(
        child: Text('Welcome, Student!'),
      ),
    );
  }
}