import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rip_college_app/screens/views/admin_screen/admin_dashboard.dart';
import 'package:rip_college_app/screens/views/admin_screen/admin_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  bool isStudentLogin = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoggedIn = false;

  //LOGIN
  Future<void> signInWithEmail(String email, String password) async {
    try {
      final AuthResponse res = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.session != null) {
        setState(() {
          _isLoggedIn = true; // Set user as logged in
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdminDashboard()
            ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please check your credentials.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  
  Future<void> logIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isNotEmpty && password.isNotEmpty) {
      signInWithEmail(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields.')),
      );
    }
  }

  // Function to handle logout
  Future<void> logOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
      setState(() {
        _isLoggedIn = false; // Reset login state
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged out successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF6F61), Color(0xFFFFA726)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Abstract shapes
          Positioned(
            top: -50,
            left: -50,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              width: isStudentLogin ? 150 : 200,
              height: isStudentLogin ? 150 : 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 100,
            right: -30,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              width: isStudentLogin ? 100 : 130,
              height: isStudentLogin ? 100 : 130,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -30,
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              width: isStudentLogin ? 200 : 250,
              height: isStudentLogin ? 200 : 250,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Login content
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo with AnimatedSwitcher
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      isStudentLogin
                          ? PhosphorIcons.student()
                          : PhosphorIcons.userCircle(),
                      key: ValueKey<bool>(isStudentLogin),
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Text(
                      isStudentLogin ? "Student Login" : "Admin Login",
                      key: ValueKey<bool>(isStudentLogin),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Login Card
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Email Field
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              PhosphorIcons.envelopeSimple(),
                              color: Colors.grey[600],
                            ),
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Password Field
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              PhosphorIcons.lockSimple(),
                              color: Colors.grey[600],
                            ),
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text("Forgot Password?"),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Login Button
                        ElevatedButton(
                          onPressed: () {
                            _isLoggedIn?{logOut()}:{logIn()};
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImagePostPage()),
                            );*/
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6F61),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            _isLoggedIn? "Log Out":" Log In",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Social Login
                        const Text(
                          "or log in with",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                PhosphorIcons.facebookLogo(),
                                size: 32,
                                color: Colors.blue[700],
                              ),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: Icon(
                                PhosphorIcons.googleLogo(),
                                size: 32,
                                color: Colors.red[700],
                              ),
                              onPressed: () {},
                            ),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: Icon(
                                PhosphorIcons.twitterLogo(),
                                size: 32,
                                color: Colors.blue,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Switch between Student and Admin Login
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isStudentLogin = !isStudentLogin;
                      });
                    },
                    child: Text(
                      isStudentLogin
                          ? "Switch to Admin Login"
                          : "Switch to Student Login",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
