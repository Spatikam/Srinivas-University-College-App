
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:rip_college_app/screens/views/base_screen/base_page.dart';
//import 'package:rip_college_app/screens/widget_common/appbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart'; // For animations

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //final TextEditingController _emailController = TextEditingController();
  //final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescController = TextEditingController();
  final TextEditingController _eventVenueController = TextEditingController();

  File? _imageFile;
  bool _isLoggedIn = false;
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = false;
  bool _isUploading = false;

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

      setState(() {
        _events = List<Map<String, dynamic>>.from(data);
      });
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
    if (_eventNameController.text.isEmpty ||
        _eventDescController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    try {
      final eventData = {
        'Name': _eventNameController.text,
        'Description': _eventDescController.text,
        'Venue': _eventVenueController.text,
        'Start_date': DateTime.now().toIso8601String(),
        'created_by': Supabase.instance.client.auth.currentUser!.id,
      };

      final response = await Supabase.instance.client
          .from('Events')
          .insert(eventData)
          .select();

      if (response.isNotEmpty) {
        setState(() {
          _events.add(response.first);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event added successfully!')),
        );
        _eventNameController.clear();
        _eventDescController.clear();
        _eventVenueController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding event: $e')),
      );
    }
  }

// Pick an image from the gallery
  Future<void> pickImage() async {
    try {
      if (Platform.isAndroid) {
        await requestPermission();
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  // Upload the selected image to Supabase storage
  Future<void> uploadImage() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final path = '2f2bf73d-2d57-4080-bd1f-2d7a7b915f09/$fileName';

      await Supabase.instance.client.storage
          .from('Proper') // Replace 'Proper' with your bucket name
          .upload(path, _imageFile!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully! File: $path')),
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

  Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.isDenied ||
          await Permission.photos.isPermanentlyDenied) {
        await Permission.photos.request();
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoggedIn
          ? SingleChildScrollView(
              child: Column(
                children: [
                  // Profile Image with Animation

                  Container(
                    width: 120,
                    height: 160,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: _imageFile != null
                          ? DecorationImage(
                              image: FileImage(_imageFile!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: Colors.grey[300],
                    ),
                    child: _imageFile == null
                        ? const Icon(Icons.person,
                            size: 50, color: Colors.white)
                        : null,
                  )
                      .animate()
                      .scale(delay: 300.ms, duration: 500.ms)
                      .fadeIn(duration: 500.ms),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: 
                      // Implement pick image logic here
                      pickImage,
                    
                    child: const Text('Pick Profile'),
                  ).animate().fadeIn(duration: 600.ms),
                  const SizedBox(height: 20),
ElevatedButton(
                    onPressed: _isUploading ? null : uploadImage,
                    child: _isUploading
                        ? const CircularProgressIndicator()
                        : const Text('Update Profile'),
                  ),
                  // Event Form with Animation
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _eventNameController,
                          decoration: const InputDecoration(
                            labelText: 'Event Name',
                            border: OutlineInputBorder(),
                          ),
                        ).animate().slideX(duration: 500.ms),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _eventDescController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                        ).animate().slideX(duration: 600.ms),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _eventVenueController,
                          decoration: const InputDecoration(
                            labelText: 'Venue',
                            border: OutlineInputBorder(),
                          ),
                        ).animate().slideX(duration: 700.ms),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: addEvent,
                          child: const Text('Add Event'),
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
                      itemCount: _events.length,
                      itemBuilder: (context, index) {
                        final event = _events[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(event['Name']),
                            subtitle: Text(event['Description']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(event['Start_date'].split('T')[0]),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    if (event['Event_Id'] != null) {
                                      deleteEvent(event['Event_Id']);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Event ID is missing. Cannot delete.')),
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
