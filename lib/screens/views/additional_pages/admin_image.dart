import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';

class GoogleFormPage extends StatefulWidget {
  @override
  _GoogleFormPageState createState() => _GoogleFormPageState();
}

class _GoogleFormPageState extends State<GoogleFormPage> {
  final _formKey = GlobalKey<FormState>();
  XFile? _selectedImage;
  String? _selectedBranch;
  String? _selectedEventType;

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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upload Event Image',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickImage,
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
                                style: GoogleFonts.poppins(
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
                const SizedBox(height: 20),
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Submit action here
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Form submitted successfully!',
                              style: GoogleFonts.poppins(),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
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
      ),
    );
  }

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
}
