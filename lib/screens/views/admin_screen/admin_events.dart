import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rip_college_app/screens/widget_common/image_controls.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart'; // For animations
import 'package:phosphor_flutter/phosphor_flutter.dart'; // For Phosphor icons

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescController = TextEditingController();
  final TextEditingController _eventVenueController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _attachmentController = TextEditingController();



  File? _imageFile;
  bool _isLoggedIn = false;
  List<Map<String, dynamic>> _events = [];
  XFile? _selectedImage;
  bool _isLoading = false;
  bool _isUploading = false;
  File? _compressedImage;
 //final CloudinaryService _cloudinaryService = CloudinaryService();
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
      fetchEvents();
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await Supabase.instance.client
          .from('Events')
          .delete()
          .eq('Event_Id', eventId);
          int index = _events.indexWhere((event) => event['Event_Id'] == eventId);
          bool isDeleted = await _pythonAnywhereService.deleteImage("suiet", _events[index]['Poster_path']);
          
    if (isDeleted) {
      print("\n\nImage Deleted Successfully\n\n");
    }else{
      print("\n\nImage Deletion Failed\n\n");
    }
    
      setState(() {
        _events.removeWhere((event) => event['Event_Id'] == eventId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting event: $e')),
      );
    }
  }

  Future<void> fetchEvents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await Supabase.instance.client
          .from('Events')
          .select()
          .order('Start_date', ascending: true)
          .limit(10);

          _events = List<Map<String, dynamic>>.from(data as List);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching events: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> addEvent() async {
    // Check if required text fields are not empty.
    if (_eventNameController.text.isEmpty || _eventDescController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    // If an image was selected, attempt to upload it.
    String? linkPath;
    if (_selectedImage != null) {
      linkPath = await uploadImage();
    }

    // Build the event data, including the image URL if available.
    final eventData = {
      'Name': _eventNameController.text,
      'Description': _eventDescController.text,
      'Venue': _eventVenueController.text,
      'Start_date': DateTime.now().toIso8601String(),
      'created_by': Supabase.instance.client.auth.currentUser!.id,
      'Start_time': _startTimeController.text,
      'End_date': _endDateController.text,
      'End_time': _endTimeController.text,
      'Link': _linkController.text,
      'Contact': _contactController.text,
      'Attachment': _attachmentController.text,
      if (linkPath != null) 'Poster_path': linkPath, // Adjust the key as needed.
    };

    try {
      final data = await Supabase.instance.client
          .from('Events')
          .insert(eventData)
          .select();

     
          _events.add((data as List).first);
          _selectedImage = null;
          _imageFile = null;
      
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event added successfully!')),
        );
        _eventNameController.clear();
        _eventDescController.clear();
        _eventVenueController.clear();
        _startTimeController.clear();
        _endDateController.clear();
        _endTimeController.clear();
        _linkController.clear();
        _contactController.clear();
        _attachmentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding event: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  /// Uploads the image using CloudinaryService and returns the image URL.
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
      _compressedImage = await _pythonAnywhereService.compressImage(_imageFile!);
      pathUrl = await _pythonAnywhereService.uploadImage(_compressedImage!, 'suiet');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image updated successfully! File: {$pathUrl}')),
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

  Future<void> pickImage() async {
    try {
      if (Platform.isAndroid) {
        await requestPermission();
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = image;
          _imageFile = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.isDenied || await Permission.photos.isPermanentlyDenied) {
        await Permission.photos.request();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final theme = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.withOpacity(0.9), theme],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: Text("Events", style: TextStyle(color: iconColor))
                    .animate()
                    .fadeIn(duration: 500.ms),
                backgroundColor: theme,
                elevation: 0,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile Image with Banner (shows selected image, if any)
                      Container(
                        width: double.infinity,
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          image: _imageFile != null
                              ? DecorationImage(
                                  image: FileImage(_imageFile!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: theme,
                        ),
                        child: _imageFile == null
                            ? Center(
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                  color: iconColor,
                                ),
                              )
                            : null,
                      ).animate().fadeIn(duration: 500.ms),
                      const SizedBox(height: 20),
                      // Profile Action: Only "Pick Profile" button remains.
                      ElevatedButton.icon(
                        onPressed: pickImage,
                        icon: PhosphorIcon(PhosphorIcons.camera()),
                        label: const Text('Pick Profile'),
                      ).animate().fadeIn(duration: 500.ms),
                      const SizedBox(height: 20),
                      // Event Input Form
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: _eventNameController,
                              decoration: InputDecoration(
                                labelText: 'Event Name',
                                border: const OutlineInputBorder(),
                                prefixIcon: PhosphorIcon(PhosphorIcons.calendar()),
                              ),
                            ).animate().slideX(duration: 500.ms),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _eventDescController,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                border: const OutlineInputBorder(),
                                prefixIcon: PhosphorIcon(PhosphorIcons.note()),
                              ),
                            ).animate().slideX(duration: 600.ms),
                            const SizedBox(height: 10),
                            TextField(
                              controller: _eventVenueController,
                              decoration: InputDecoration(
                                labelText: 'Venue',
                                border: const OutlineInputBorder(),
                                prefixIcon: PhosphorIcon(PhosphorIcons.mapPin()),
                              ),
                            ).animate().slideX(duration: 700.ms),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _startTimeController,
                              decoration: InputDecoration(
                                labelText: 'Start Time',
                                border: const OutlineInputBorder(),
                                prefixIcon: PhosphorIcon(PhosphorIcons.clock()),
                              ),
                            ).animate().slideX(duration: 800.ms),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _endDateController,
                              decoration: InputDecoration(
                                labelText: 'End Date',
                                border: const OutlineInputBorder(),
                                prefixIcon: PhosphorIcon(PhosphorIcons.calendar()),
                              ),
                            ).animate().slideX(duration: 900.ms),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _endTimeController,
                              decoration: InputDecoration(
                                labelText: 'End Time',
                                border: const OutlineInputBorder(),
                                prefixIcon: PhosphorIcon(PhosphorIcons.clock()),
                              ),
                            ).animate().slideX(duration: 1000.ms),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _linkController,
                              decoration: InputDecoration(
                                labelText: 'Link',
                                border: const OutlineInputBorder(),
                                prefixIcon: PhosphorIcon(PhosphorIcons.linkSimple()),
                              ),
                            ).animate().slideX(duration: 1100.ms),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _contactController,
                              decoration: InputDecoration(
                                labelText: 'Contact',
                                border: const OutlineInputBorder(),
                                prefixIcon: PhosphorIcon(PhosphorIcons.phone()),
                              ),
                            ).animate().slideX(duration: 1200.ms),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _attachmentController,
                              decoration: InputDecoration(
                                labelText: 'Attachment',
                                border: const OutlineInputBorder(),
                                prefixIcon: PhosphorIcon(PhosphorIcons.paperclip()),
                              ),
                            ).animate().slideX(duration: 1300.ms),
                            const SizedBox(height: 16),
                            
                            ElevatedButton.icon(
                              onPressed: _isUploading ? null : addEvent,
                              icon: _isUploading
                                  ? const CircularProgressIndicator()
                                  : PhosphorIcon(PhosphorIcons.plusCircle()),
                              label: const Text('Add Event'),
                            ).animate().fadeIn(duration: 800.ms),
                          ],
                        ),
                      ),
                      // Events List
                      _isLoading
                          ? const CircularProgressIndicator()
                              .animate()
                              .fadeIn(duration: 500.ms)
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _events.length,
                              itemBuilder: (context, index) {
                                final event = _events[index];
                                return Card(
                                  color: theme.withOpacity(0.9),
                                  margin: const EdgeInsets.all(8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      event['Name'],
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(event['Description']),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(event['Start_date'].split('T')[0]),
                                        IconButton(
                                          icon: PhosphorIcon(PhosphorIcons.trash()),
                                          onPressed: () {
                                            deleteEvent(event['Event_Id']);
                                          },
                                          color: Colors.red,
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
            ],
          ),
        ),
      ),
    );
  }
}