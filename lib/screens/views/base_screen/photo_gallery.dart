import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PhotoGallery extends StatefulWidget {
  final List<String> imagePaths;

  const PhotoGallery({Key? key, required this.imagePaths}) : super(key: key);

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isFullScreen = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildGallery(),
          if (_isFullScreen) _buildFullScreenViewer(),
        ],
      ),
    );
  }

  Widget _buildGallery() {
    return GridView.custom(
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Tile(imagePath: widget.imagePaths[index]),
            ),
          );
        },
        childCount: widget.imagePaths.length,
      ),
    );
  }

  Widget _buildFullScreenViewer() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFullScreen = false;
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: ColoredBox(color: Colors.black),
            ),
          ),
          Center(
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.imagePaths.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  panEnabled: true,
                  minScale: 1.0,
                  maxScale: 5.0,
                  child: Image.asset(
                    widget.imagePaths[index],
                    fit: BoxFit.contain,
                  ),
                );
              },
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