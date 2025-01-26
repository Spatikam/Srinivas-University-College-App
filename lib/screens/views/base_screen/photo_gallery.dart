import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PhotoGallery extends StatefulWidget {
  final List<String> imagePaths;

  PhotoGallery({required this.imagePaths});

  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  int _selectedImageIndex = -1;
  double _selectedImageScale = 1.0;
  Offset? _startPosition;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GridView.custom(
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
                onTapDown: (details) {
                  setState(() {
                    if (_selectedImageIndex == -1)
                      _selectedImageIndex = index;
                    else
                      _selectedImageIndex = -1;
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    transform: _selectedImageIndex == index
                        ? Matrix4.identity()
                        : Matrix4.identity()
                      ..scale(_selectedImageScale),
                    child: Tile(imagePath: widget.imagePaths[index]),
                  ),
                ),
              );
            },
            childCount: widget.imagePaths.length,
          ),
        ),
        if (_selectedImageIndex != -1)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedImageIndex = -1;
                });
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
          ),
        if (_selectedImageIndex != -1)
          Center(
            child: Hero(
              tag: widget.imagePaths[_selectedImageIndex],
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  widget.imagePaths[_selectedImageIndex],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
      ],
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
