import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rip_college_app/screens/views/content_pages/event_page.dart';
import 'package:rip_college_app/screens/widget_common/image_controls.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart'; // For animations
import 'package:phosphor_flutter/phosphor_flutter.dart'; // For Phosphor icons
import 'package:intl/intl.dart'; // For formatting date/time

class PopupPage extends StatefulWidget {
  final String uuid;
  const PopupPage({super.key, required this.uuid});

  @override
  State<PopupPage> createState() => _PopupPageState();
}

class _PopupPageState extends State<PopupPage> {
  // Controllers for event details.
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _attachmentController = TextEditingController();

  File? _imageFile;
  bool _isLoggedIn = false;
  List<Map<String, dynamic>> _events = [];
  XFile? _selectedImage;
  bool _isLoading = false;
  bool _isUploading = false;
  File? _compressedImage;
  final PythonAnywhereService _pythonAnywhereService = PythonAnywhereService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  // Danger
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
    log("Works");
    try {
      await Supabase.instance.client.from('Popups').delete().eq('id', eventId);
      int index = _events.indexWhere((event) => event['id'] == eventId);
      bool isDeleted = await _pythonAnywhereService.deleteImage("suiet", _events[index]['image']);
      log("Status: $isDeleted");
      setState(() {
        _events.removeWhere((event) => event['id'] == eventId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Deleting Event')),
      );
    }
  }

  Future<void> fetchEvents() async {
    setState(() {
      _isLoading = true;
    });
    if (widget.uuid != "") {
      try {
        final data = await Supabase.instance.client.from('Popups').select('*').order('start_timestamp', ascending: true);
        setState(() {
          _events = List<Map<String, dynamic>>.from(data);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error Fetching Popups')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
    // Build the event data.
    final eventData = {
      'title': _eventNameController.text,
      'desc': _eventDescController.text,
      'start_timestamp': (_startDateController.text != "") ? DateTime.parse(_startDateController.text).toUtc().toIso8601String() : null, // using picked date
      'end_timestamp': (_endDateController.text != "") ? DateTime.parse(_endDateController.text).toUtc().toIso8601String() : null,
      'link': (_linkController.text != "") ? _linkController.text : null,
      'target_insti': Supabase.instance.client.auth.currentUser!.id,
      if (linkPath != null) 'image': linkPath,
    };
    try {
      final data = await Supabase.instance.client.from('Popups').insert(eventData).select();
      _events.add((data as List).first);
      _selectedImage = null;
      _imageFile = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event added successfully!')),
      );
      _eventNameController.clear();
      _eventDescController.clear();
      _startDateController.clear();
      _endDateController.clear();
      _linkController.clear();
      _attachmentController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Adding Event')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
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
      _compressedImage = await _pythonAnywhereService.compressImage(_imageFile!);
      pathUrl = await _pythonAnywhereService.uploadImage(_compressedImage!, 'suiet');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image Uploaded Successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Uploading Image')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
    return pathUrl;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    bool hasPermission = await _pythonAnywhereService.requestStoragePermission();
    if (hasPermission) {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _selectedImage = image;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Media access permission required')),
      );
    }
  }

  //Date Picker
  Future<void> _selectDate({required TextEditingController controller}) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _showEventDetails(BuildContext context, EventCard eventCard) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(eventCard.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(eventCard.imagePath),
              Text(eventCard.description),
              Text('Date: ${eventCard.date}'),
              Text('Venue: ${eventCard.venue}'),
              Text('Contact: ${eventCard.contact}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    //final iconColor = isDarkMode ? Colors.white : Colors.black;
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Upload Popup Event Image',
                              style: GoogleFonts.kanit(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: pickImage,
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
                            const SizedBox(height: 15),
                            TextField(
                              controller: _eventNameController,
                              decoration: InputDecoration(
                                labelText: 'Popup Event Name',
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
                            const SizedBox(height: 16),
                            // Start Date Field with Calendar Picker.
                            TextField(
                              controller: _startDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'Start Date',
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.calendar_today),
                              ),
                              onTap: () => _selectDate(controller: _startDateController),
                            ).animate().slideX(duration: 800.ms),
                            const SizedBox(height: 16),
                            // End Date Field with Calendar Picker.
                            TextField(
                              controller: _endDateController,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'End Date',
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.calendar_today),
                              ),
                              onTap: () => _selectDate(controller: _endDateController),
                            ).animate().slideX(duration: 1000.ms),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _linkController,
                              decoration: InputDecoration(
                                labelText: 'Link',
                                border: const OutlineInputBorder(),
                                prefixIcon: PhosphorIcon(PhosphorIcons.linkSimple()),
                              ),
                            ).animate().slideX(duration: 1200.ms),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _isUploading ? null : addEvent,
                              icon: _isUploading ? const CircularProgressIndicator() : PhosphorIcon(PhosphorIcons.plusCircle()),
                              label: const Text('Create Popup'),
                            ).animate().fadeIn(duration: 800.ms),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Events List
                      _isLoading
                          ? const CircularProgressIndicator().animate().fadeIn(duration: 500.ms)
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _events.length,
                              itemBuilder: (context, index) {
                                final event = _events[index];
                                final imageUrl =
                                    (event['image'] != null && event['image'].toString().isNotEmpty) ? _pythonAnywhereService.getImageUrl("suiet", event['image']) : "assets/images/default_event.jpg";
                                return GestureDetector(
                                  onTap: () => _showEventDetails(
                                      context,
                                      EventCard(
                                        title: event['Name'] ?? "No Title",
                                        date: event['Start_date'] != null ? event['Start_date'].split('T')[0] : "",
                                        venue: event['Venue'] ?? "",
                                        imagePath: imageUrl,
                                        description: event['Description'] ?? "",
                                        contact: event['Contact'].toString(),
                                      )),
                                  child: EventCard(
                                    title: event['title'] ?? "No Title",
                                    date: event['start_timestamp'] != null ? event['start_timestamp'].split('T')[0] : "",
                                    venue: event['Venue'] ?? "",
                                    imagePath: imageUrl,
                                    description: event['desc'] ?? "",
                                    contact: event['Contact'].toString(),
                                    del_op: true,
                                    onDelPressed: () {
                                      log("Pressed");
                                      if (event['id'] != null) {
                                        log("Deleting: ${event['id']}");
                                        deleteEvent(event['id']);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Event ID is missing, cannot delete.')),
                                        );
                                      }
                                    },
                                  ),
                                );
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
