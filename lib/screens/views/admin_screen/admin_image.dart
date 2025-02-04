import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImagePostPage extends StatefulWidget {
  const ImagePostPage({super.key});

  @override
  _ImagePostPageState createState() => _ImagePostPageState();
}

class _ImagePostPageState extends State<ImagePostPage> {
  List<XFile>? _selectedImages = [];
  File? _imageFile;
  //String? _selectedBranch;
  //String? _selectedEventType;
  bool _isUploading = false;

  final List<String> branches = [
    'Computer Science',
    'Mechanical Engineering',
    'Electronics',
    'Civil Engineering',
    'Information Technology'
  ];

  final List<String> eventTypes = [
    'Cultural',
    'Technical',
    'Sports',
    'Workshop',
    'Seminar'
  ];

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    setState(() {
      _selectedImages = images;
    });
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

    try {

      for (XFile image_file in _selectedImages!) {
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final path = '2f2bf73d-2d57-4080-bd1f-2d7a7b915f09/Events/$fileName';

        _imageFile = File(image_file.path);
        await Supabase.instance.client.storage
            .from('Proper') // Replace 'Proper' with your bucket name
            .upload(path, _imageFile!);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Images updated successfully! File')),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Event Registration',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload Event Images',
                style: GoogleFonts.poppins(
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
                              style: GoogleFonts.poppins(
                                color: Colors.deepPurple,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        )
                      : _buildImagePreview(),
                ),
              ),
              /*const SizedBox(height: 20),
                _buildDropdown(
                  title: 'Select Branch',
                  items: branches,
                  value: _selectedBranch,
                  onChanged: (value) {
                    setState(() {
                      _selectedBranch = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildDropdown(
                  title: 'Type of Event',
                  items: eventTypes,
                  value: _selectedEventType,
                  onChanged: (value) {
                    setState(() {
                      _selectedEventType = value;
                    });
                  },
                ),
                */
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
                    'Submit',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*
  Widget _buildDropdown({
    required String title,
    required List<String> items,
    required String? value,
    required void Function(String?) onChanged,
  }) {
    return FadeInUp(
      duration: const Duration(milliseconds: 600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: value,
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.deepPurple.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.deepPurple),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.deepPurple),
              ),
            ),
          ),
        ],
      ),
    );
  }
*/
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
