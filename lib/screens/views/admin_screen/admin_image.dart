import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rip_college_app/screens/widget_common/image_controls.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImagePostPage extends StatefulWidget {
  final String uuid;
  const ImagePostPage({super.key, required this.uuid});

  @override
  _ImagePostPageState createState() => _ImagePostPageState();
}

class _ImagePostPageState extends State<ImagePostPage> {
  List<XFile>? _selectedImages = [];
  File? _imageFile;
  File? _compressedImage;
  bool _isUploading = false;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  List<Map<String, dynamic>> imagepaths = [];
  final PythonAnywhereService _pythonAnywhereService = PythonAnywhereService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    print("DIE");
  }

  Future<void> _checkAuthStatus() async {
    final user = Supabase.instance.client.auth.currentUser;
    setState(() {
      _isLoggedIn = user != null;
    });
    if (_isLoggedIn) {
      fetchimages();
    }
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    setState(() {
      _selectedImages = images;
    });
  }

  Future<void> fetchimages() async {
    setState(() {
      _isLoading = true;
    });
    try {
      print('LIVE');
      final response = await Supabase.instance.client
          .from('Gallery')
          .select("*")
          .eq('Created_by', widget.uuid);
      imagepaths = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Supabase error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching Images: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> uploadImage() async {
    if (_selectedImages == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    String? pathUrl;

    try {
      for (XFile image_file in _selectedImages!) {
        _imageFile = File(image_file.path);
        _compressedImage =
            await _pythonAnywhereService.compressImage(_imageFile!);
        pathUrl = await _pythonAnywhereService.uploadImage(
            _compressedImage!, 'gallery');
        final GalleryData = {
          'Filename': pathUrl,
        };
        final response = await Supabase.instance.client
            .from('Gallery')
            .insert(GalleryData)
            .select();

        if (response.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Images updated successfully!')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> deleteimage(String Filename) async {
    try {
      await Supabase.instance.client
          .from('Gallery')
          .delete()
          .eq('Filename', Filename);

      int index = imagepaths
          .indexWhere((imagePath) => imagePath['Filename'] == Filename);

      bool isDeleted = await _pythonAnywhereService.deleteImage(
          "gallery",
          _pythonAnywhereService.getImageUrl(
              "gallery", imagepaths[index]['Filename']));

      if (isDeleted) {
        print("Image deleted successfully!");
      } else {
        print("Failed to delete image.");
      }
      setState(() {
        imagepaths
            .removeWhere((imagePath) => imagePath['Filename'] == Filename);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Images Detail deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting Images Detail: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload Images',
                style: GoogleFonts.kanit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.deepPurple,
                      width: 2,
                    ),
                  ),
                  child: _selectedImages == null || _selectedImages!.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload,
                              size: 50,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Tap to upload images',
                              style: GoogleFonts.kanit(
                                color: Colors.deepPurple,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                      : _buildImagePreview(),
                ),
              ),
              const SizedBox(height: 30),
              FadeIn(
                duration: const Duration(milliseconds: 800),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                  ),
                  onPressed: _isUploading ? null : uploadImage,
                  child: Text(
                    'Upload',
                    style: GoogleFonts.kanit(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                /*const CircularProgressIndicator()
                        .animate()
                        .fadeIn(duration: 500.ms)*/

                if (!_isLoading)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: imagepaths.length,
                    itemBuilder: (context, index) {
                      final imagePath = imagepaths[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(imagePath['Filename']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(
                                _pythonAnywhereService.getImageUrl(
                                    "gallery", imagepaths[index]['Filename']),
                                fit: BoxFit.cover,
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  if (imagePath['Filename'] != null) {
                                    deleteimage(imagePath['Filename']);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Filename is missing. Cannot delete.')),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: (100 * index).ms);
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(_selectedImages![index].path),
                width: 150,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
