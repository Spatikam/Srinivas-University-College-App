import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LiquidGlassPopup extends StatefulWidget {
  final VoidCallback onClose;

  const LiquidGlassPopup({super.key, required this.onClose});

  @override
  State<LiquidGlassPopup> createState() => _LiquidGlassPopupState();
}

class _LiquidGlassPopupState extends State<LiquidGlassPopup>
    with TickerProviderStateMixin {
  late AnimationController _popupController;
  late AnimationController _blobController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _popupController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _popupController, curve: Curves.easeOutQuad);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _popupController, curve: Curves.easeOutBack),
    );

    _blobController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _popupController.forward();
  }

  Future<void> _launchWebsite() async {
    const url = "https://your-college-website.com";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _popupController.dispose();
    _blobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final isDark = theme.brightness == Brightness.dark;

    // Glass popup positioned at top-center (no screen background)
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: Container(
                width: size.width * 0.9,
                constraints: BoxConstraints(maxHeight: size.height * 0.6),
                decoration: BoxDecoration(
                  color: (isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.white.withOpacity(0.25))
                      .withOpacity(0.25),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // 🩷 Moving blob
                    AnimatedBuilder(
                      animation: _blobController,
                      builder: (context, _) {
                        final x = sin(_blobController.value * 2 * pi) * 20;
                        final y = cos(_blobController.value * 2 * pi) * 20;

                        return Positioned(
                          left: 100 + x,
                          top: 50 + y,
                          child: _buildBlob(isDark),
                        );
                      },
                    ),

                    // 🧊 Glass blur & content
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Icon(Icons.close_rounded,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black87),
                                onPressed: widget.onClose,
                              ),
                            ),
                            Text(
                              "Welcome to My College",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : Colors.black.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                "assets/images/poster.jpg",
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Explore academics, innovation, and opportunities at our vibrant campus.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white70
                                    : Colors.black.withOpacity(0.6),
                                fontSize: 15,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _launchWebsite,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark
                                    ? Colors.white.withOpacity(0.15)
                                    : Colors.white.withOpacity(0.35),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 14),
                                elevation: 0,
                              ),
                              child: Text(
                                "Visit Website",
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildBlob(bool isDark) {
    final color = isDark
        ? Colors.pinkAccent.withOpacity(0.25)
        : Colors.pinkAccent.withOpacity(0.35);
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 70,
            spreadRadius: 25,
          ),
        ],
      ),
    );
  }
}
