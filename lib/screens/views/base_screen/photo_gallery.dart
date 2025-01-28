import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

class PhotoGallery extends StatefulWidget {
  final List<String> imagePaths;

  const PhotoGallery({Key? key, required this.imagePaths}) : super(key: key);

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  int _currentIndex = 0;
  bool _isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    //final primaryColor = Color(0xFF658CC2);
    //final iconColor = isDarkMode ? Colors.white : Colors.black;
    final themeColor = isDarkMode ? Colors.black : Colors.white;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Event Gallery',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: themeColor,
        elevation: 4,
      ),
      body: Stack(
        children: [
          _buildGallery(),
          if (_isFullScreen) _buildFullScreenViewer(_currentIndex),
        ],
      ),
    );
  }

  Widget _buildGallery() {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    //final primaryColor = Color(0xFF658CC2);
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final themeColor = isDarkMode ? Colors.black : Colors.white;
    return Container(
        decoration: BoxDecoration(
          color: themeColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Memorable Moments',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Relive the moments from our events!',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.custom(
                gridDelegate: SliverQuiltedGridDelegate(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  repeatPattern: QuiltedGridRepeatPattern.inverted,
                  pattern: [
                    QuiltedGridTile(2, 2),
                    QuiltedGridTile(1, 1),
                    QuiltedGridTile(1, 1),
                    QuiltedGridTile(1, 2),
                  ],
                ),
                childrenDelegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentIndex = index;
                          _isFullScreen = true;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: iconColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Tile(imagePath: widget.imagePaths[index]),
                        ),
                      ),
                    );
                  },
                  childCount: widget.imagePaths.length,
                ),
              ),
            ),
          ],
          ),
        ),
    );
  }

  Widget _buildFullScreenViewer(int x) {
    final PageController _pageController = PageController(initialPage: x);
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFullScreen = false;
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 3.0,
              child: PageView.builder(
                itemCount: widget.imagePaths.length,
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.asset(
                    widget.imagePaths[_currentIndex],
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final String imagePath;

  const Tile({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(imagePath, fit: BoxFit.cover);
  }
}
