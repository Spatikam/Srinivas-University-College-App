import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rip_college_app/screens/widget_common/image_controls.dart';
import 'package:rip_college_app/screens/widget_common/web_view.dart';

class LiquidImagePopup extends StatefulWidget {
  final String imagePath;
  final String websiteUrl;
  final VoidCallback onClose;

  const LiquidImagePopup({
    super.key,
    required this.imagePath,
    this.websiteUrl = "",
    required this.onClose,
  });

  @override
  State<LiquidImagePopup> createState() => _LiquidImagePopupState();
}

class _LiquidImagePopupState extends State<LiquidImagePopup> with TickerProviderStateMixin {
  late AnimationController _popupController;
  late AnimationController _tapHintController;
  late AnimationController _backgroundController;
  late AnimationController _tapShrinkController;

  late Animation<double> _fadePopup;
  late Animation<Offset> _slidePopup;

  late Animation<double> _tapScale;
  late Animation<Offset> _tapSlide;
  late Animation<double> _tapFade;

  late Animation<double> _imageScale;
  final PythonAnywhereService _pythonAnywhereService = PythonAnywhereService();

  @override
  void initState() {
    super.initState();

    // Popup entrance animation
    _popupController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadePopup = CurvedAnimation(parent: _popupController, curve: Curves.easeOutQuad);
    _slidePopup = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _popupController, curve: Curves.easeOutBack),
    );
    _popupController.forward();

    // Tap hint animation outside the image
    _tapHintController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _tapScale = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _tapHintController,
      curve: Curves.easeInOut,
    ));
    _tapSlide = Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, 0.05)).animate(CurvedAnimation(parent: _tapHintController, curve: Curves.easeInOut));
    _tapFade = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
      parent: _tapHintController,
      curve: Curves.easeInOut,
    ));

    // Background animation
    _backgroundController = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat(reverse: true);

    // Image shrink animation
    _tapShrinkController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _imageScale = Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _tapShrinkController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _popupController.dispose();
    _tapHintController.dispose();
    _backgroundController.dispose();
    _tapShrinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // 🔹 Animated background
        AnimatedBuilder(
          animation: _backgroundController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    isDark ? Colors.black.withOpacity(0.6 + 0.1 * (_backgroundController.value)) : Colors.white.withOpacity(0.2 + 0.05 * (_backgroundController.value)),
                    isDark ? Colors.deepPurple.withOpacity(0.4 + 0.1 * (_backgroundController.value)) : Colors.blue.withOpacity(0.1 + 0.05 * (_backgroundController.value)),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            );
          },
        ),

        // 🔹 Background blur
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(color: Colors.transparent),
        ),

        // 🔹 Popup animation
        FadeTransition(
          opacity: _fadePopup,
          child: SlideTransition(
            position: _slidePopup,
            child: Center(
              child: ScaleTransition(
                scale: _imageScale,
                child: GestureDetector(
                  onTap: () {
                    if (widget.websiteUrl.isNotEmpty) {
                      _tapShrinkController.forward().then((_) => _tapShrinkController.reverse());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewPage(
                                  url: widget.websiteUrl,
                                )),
                      );
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image
                      Image.network(
                        _pythonAnywhereService.getImageUrl("suiet", widget.imagePath),
                        height: size.height * 0.55,
                        width: size.width * 0.85,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                      ),
                      /*Image.asset(
                        widget.imagePath,
                        width: size.width * 0.85,
                        height: size.height * 0.55,
                        fit: BoxFit.contain,
                      ),*/
                      const SizedBox(height: 20),

                      // 🔹 Tap Here hint outside the image
                      SlideTransition(
                        position: _tapSlide,
                        child: ScaleTransition(
                          scale: _tapScale,
                          child: FadeTransition(
                            opacity: _tapFade,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(PhosphorIconsBold.handTap, color: Colors.white, size: 28),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Text(
                                    "TAP HERE",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
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

        // 🔹 Close button outside
        Positioned(
          top: 60,
          right: 30,
          child: IconButton(
            icon: Icon(Icons.close_rounded, color: isDark ? Colors.white70 : Colors.black87, size: 30),
            onPressed: widget.onClose,
          ),
        ),
      ],
    );
  }
}
