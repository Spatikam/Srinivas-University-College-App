import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rip_college_app/main.dart';
import 'package:rip_college_app/screens/views/login_screen/login_page.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String collegeName;
  final bool slide_menu_access;
  const CustomAppBar(
      {super.key, this.collegeName = "", this.slide_menu_access = true});
  @override
  _CustomAppBar createState() => _CustomAppBar();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBar extends State<CustomAppBar> with TickerProviderStateMixin {
  bool _isMenuOpen = false;

  void _openSlidingMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });

    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    void toggleTheme() {
      setState(() {
        isDarkMode = !isDarkMode;
        themeProvider.toggleTheme(isDarkMode);
        print("toggled $isDarkMode");
      });
    }

    if (_isMenuOpen) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.3,
            maxChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2A5298), Color(0xFF1E3C72)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                _isMenuOpen = false;
                              });
                            },
                          ),
                        ],
                      ),
                      _buildDrawerItem(context,
                          icon: isDarkMode
                              ? PhosphorIcons.toggleLeft()
                              : PhosphorIcons.toggleRight(),
                          text: isDarkMode
                              ? 'Switch to Light Mode'
                              : 'Switch to Dark Mode',
                          onTap: toggleTheme),
                      _buildDrawerItem(
                        context,
                        icon: PhosphorIcons.user(),
                        text: 'Account',
                        onTap: () => Navigator.push(
                          context,
                          _createPageRoute(LoginPage()),
                        ),
                      ),
                      _buildDrawerItem(
                        context,
                        icon: PhosphorIcons.lock(),
                        text: 'Privacy',
                        onTap: () => print('Privacy tapped'),
                      ),
                      _buildDrawerItem(
                        context,
                        icon: PhosphorIcons.shieldCheck(),
                        text: 'Privacy Policy',
                        onTap: () => print('Privacy Policy tapped'),
                      ),
                      _buildDrawerItem(
                        context,
                        icon: PhosphorIcons.question(),
                        text: 'Help',
                        onTap: () => print('Help tapped'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }

  PageRouteBuilder _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from the right
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, size: 28, color: Colors.white),
      title: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF658CC2);
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Srinivas University',
                    style: GoogleFonts.kanit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    widget.collegeName,
                    style: GoogleFonts.kanit(
                      fontSize: 16, // Slightly smaller font for "Engineering"
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: widget.slide_menu_access
          ? [
              IconButton(
                icon: PhosphorIcon(
                  PhosphorIcons.dotsThreeOutline(), // Phosphor menu icon
                  color: iconColor,
                  size: 28, // Adjust size if needed
                ),
                onPressed: _openSlidingMenu,
              ),
            ]
          : null,
    );
  }

  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
