
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rip_college_app/screens/widget_common/image_controls.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ArticleUpload extends StatefulWidget {
  const ArticleUpload({super.key});

  @override
  State<ArticleUpload> createState() => _ArticleUploadState();
}

class _ArticleUploadState extends State<ArticleUpload> {
  final TextEditingController _headingController = TextEditingController();
  final TextEditingController _publishedByController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  bool _isLoggedIn = false;
  bool _isLoading = false;
  List<Map<String, dynamic>> _articles = [];
  XFile? _selectedImage;
  File? _imageFile;
  bool _isUploading = false;
  File? _compressedImage;

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
      fetchArticles();
    }
  }

  Future<void> fetchArticles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await Supabase.instance.client.from('Articles').select('*');
      setState(() {
        _articles = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching articles: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> addArticle() async {
    if (_headingController.text.isEmpty || _publishedByController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    try {
      String? imagePath = await uploadImage();
      final articleData = {
        'Heading': _headingController.text,
        'Published_by': _publishedByController.text,
        'Description': _descriptionController.text,
        'Image_path': imagePath,
        'op_id': Supabase.instance.client.auth.currentUser!.id,
      };

      final response = await Supabase.instance.client
          .from('Articles')
          .insert(articleData)
          .select();

      if (response.isNotEmpty) {
        setState(() {
          _articles.add(response.first);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Article added successfully!')),
        );
        _headingController.clear();
        _publishedByController.clear();
        _descriptionController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding article: $e')),
      );
    }
  }

  Future<void> deleteArticle(String articleId) async {
    try {
      await Supabase.instance.client.from('Articles').delete().eq('Article_id', articleId);
     
       int index=_articles.indexWhere((article) => article['Article_id'] == articleId);

       bool isDeleted = await _pythonAnywhereService.deleteImage("suiet", _articles[index]['Image_path']);
        if(isDeleted){
          print("Image Deleted");
        }else{
          print("Image Not Deleted");
        }
     setState(() {
        _articles.removeWhere((article) => article['Article_id'] == articleId);
     });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting article: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = image;
    });
  }

  Future<String?> uploadImage() async {
    if (_selectedImage == null) {
      return null;
    }

    setState(() {
      _isUploading = true;
    });
    String? pathurl;

    try {
      _imageFile = File(_selectedImage!.path);
      _compressedImage = await _pythonAnywhereService.compressImage(_imageFile!);
      pathurl = await _pythonAnywhereService.uploadImage( _compressedImage!,"suiet");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully!')),
      );
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: ${e.toString()}')),
      );
      return null;
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
    return pathurl;
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
                          'Upload Article Image',
                          style: GoogleFonts.kanit(
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
                                      Icon(Icons.cloud_upload, size: 50, color: Colors.deepPurple),
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
                          controller: _headingController,
                          decoration: const InputDecoration(
                            labelText: 'Heading',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _publishedByController,
                          decoration: const InputDecoration(
                            labelText: 'Published By',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: addArticle,
                          child: const Text('Add Article'),
                        ),
                      ],
                    ),
                  ),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _articles.length,
                      itemBuilder: (context, index) {
                        final article = _articles[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(article['Heading']),
                            subtitle: Text(article['Published_by']),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                if (article['Article_id'] != null) {
                                  deleteArticle(article['Article_id']);
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            )
          : const Center(child: Text("Please log in to add articles.")),
    );
  }
}
