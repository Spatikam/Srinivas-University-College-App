import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rip_college_app/screens/widget_common/image_controls.dart';
//import 'package:rip_college_app/screens/widget_common/image_upload.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:path/path.dart' as path;

class Placement_Update extends StatefulWidget {
  final String uuid;
  const Placement_Update({super.key, required this.uuid});

  @override
  State<Placement_Update> createState() => _Placement_UpdateState();
}

class _Placement_UpdateState extends State<Placement_Update> {
  final TextEditingController _PlacementNameController =
      TextEditingController();
  final TextEditingController _PlacementLPAController = TextEditingController();
  final TextEditingController _PlacementCompanyController =
      TextEditingController();

  bool _isLoggedIn = false;
  bool _isLoading = false;
  List<Map<String, dynamic>> _placements = [];
  XFile? _selectedImage;
  File? _imageFile;
  File? _compressedImage;
  bool _isUploading = false;

  final PythonAnywhereService _pythonAnywhereService = PythonAnywhereService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final user = Supabase.instance.client.auth.currentUser;
    setState(() {
      _isLoggedIn = user != null;
    });
    if (_isLoggedIn) {
      fetchPlacements();
    }
  }

  Future<void> deletePlacement(String placementId) async {
    try {
      await Supabase.instance.client
          .from('Placements')
          .delete()
          .eq('Placement_Id', placementId);

      int index = _placements
          .indexWhere((placement) => placement['Placement_Id'] == placementId);

      bool isDeleted = await _pythonAnywhereService.deleteImage(
          "suiet", _placements[index]['Link']);

      if (isDeleted) {
        print("Image deleted successfully!");
      } else {
        print("Failed to delete image.");
      }
      setState(() {
        _placements.removeWhere(
            (placement) => placement['Placement_Id'] == placementId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Placement Detail deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting Placement Detail: $e')),
      );
    }
  }

  Future<void> fetchPlacements() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data =
          await Supabase.instance.client.from('Placements').select('*').eq('Uploaded_by', widget.uuid);

      setState(() {
        _placements = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching Placement: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> addPlacement() async {
    if (_PlacementNameController.text.isEmpty ||
        _PlacementLPAController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    try {
      String? linkPath = await uploadImage();
      print("link: $linkPath");
      final PlacementData = {
        'Name': _PlacementNameController.text,
        'LPA': _PlacementLPAController.text,
        'Company_Name': _PlacementCompanyController.text,
        'Uploaded_by': Supabase.instance.client.auth.currentUser!.id,
        'Link': linkPath,
      };

      final response = await Supabase.instance.client
          .from('Placements')
          .insert(PlacementData)
          .select();

      if (response.isNotEmpty) {
        setState(() {
          _placements.add(response.first);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Placement added successfully!')),
        );
        _PlacementNameController.clear();
        _PlacementLPAController.clear();
        _PlacementCompanyController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding Placement Details: $e')),
      );
    }
  }

  Future<void> _pickimage() async {
    final ImagePicker picker = ImagePicker();
    bool hasPermission =
        await _pythonAnywhereService.requestStoragePermission();
    if (hasPermission) {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _selectedImage = image;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Media acess permission required')),
      );
    }
  }

  Future<String?> uploadImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first.')),
      );
      return null;
    }

    setState(() {
      _isUploading = true;
    });

    String? pathUrl;

    try {
      _imageFile = File(_selectedImage!.path);

      _compressedImage =
          await _pythonAnywhereService.compressImage(_imageFile!);

      pathUrl =
          await _pythonAnywhereService.uploadImage(_compressedImage!, 'suiet');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('image updated successfully! File: $pathUrl')),
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
    return pathUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoggedIn
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Upload Event image',
                          style: GoogleFonts.kanit(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: _pickimage,
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
                            child: _selectedImage == null
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
                                        'Tap to upload image',
                                        style: GoogleFonts.kanit(
                                          color: Colors.deepPurple,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      File(_selectedImage!.path),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _PlacementNameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                        ).animate().slideX(duration: 500.ms),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _PlacementLPAController,
                          decoration: const InputDecoration(
                            labelText: 'LPA',
                            border: OutlineInputBorder(),
                          ),
                        ).animate().slideX(duration: 600.ms),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _PlacementCompanyController,
                          decoration: const InputDecoration(
                            labelText: 'Company Name',
                            border: OutlineInputBorder(),
                          ),
                        ).animate().slideX(duration: 700.ms),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: addPlacement,
                          child: const Text('Add Placement'),
                        ).animate().fadeIn(duration: 800.ms),
                      ],
                    ),
                  ),

                  // Events List with Animation
                  if (_isLoading)
                    const CircularProgressIndicator()
                        .animate()
                        .fadeIn(duration: 500.ms)
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _placements.length,
                      itemBuilder: (context, index) {
                        final placement = _placements[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(placement['Name']),
                            subtitle: Text(placement['LPA'].toString()),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(placement['Company_Name']),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    if (placement['Placement_Id'] != null) {
                                      deletePlacement(
                                          placement['Placement_Id']);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Placement ID is missing. Cannot delete.')),
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
            )
          : const Center(child: Text("Please log in to view your profile.")),
    );
  }
}
