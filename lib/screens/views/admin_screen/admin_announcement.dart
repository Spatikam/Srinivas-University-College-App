import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart'; // For animations
import 'package:phosphor_flutter/phosphor_flutter.dart'; // For Phosphor icons

class AddAnnouncementScreen extends StatefulWidget {
  final String uuid;
  const AddAnnouncementScreen({super.key, required this.uuid});

  @override
  State<AddAnnouncementScreen> createState() => _AddAnnouncementScreenState();
}

class _AddAnnouncementScreenState extends State<AddAnnouncementScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  bool _isLoading = false;
  bool _isLoggedIn = false;
  List<Map<String, dynamic>> _announcements = [];

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
      fetchAnnouncements();
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    try {
      await Supabase.instance.client.from('Announcements').delete().eq('id', id);
      setState(() {
        _announcements.removeWhere((announcement) => announcement['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Announcement deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network Error')),
      );
    } 
  }

  Future<void> fetchAnnouncements() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data = await Supabase.instance.client
          .from('Announcements')
          .select()
          .eq('owner_id', widget.uuid)
          .order('Created_At', ascending: false)
          .limit(10);

        _announcements = List<Map<String, dynamic>>.from(data);
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching Announcements')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> addAnnouncement() async {
    if (_nameController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }
    try {
      final response = await Supabase.instance.client.from('Announcements').insert({
        'Name': _nameController.text,
        'Description': _descriptionController.text,
        'Type': _typeController.text,
        'Created_At': DateTime.now().toIso8601String(),
        'owner_id' : Supabase.instance.client.auth.currentUser!.id,
      }).select();
      if (response.isNotEmpty) {
        setState(() {
          _announcements.add(response.first);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Announcement added successfully!')),
        );
        _nameController.clear();
        _descriptionController.clear();
        _typeController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding Announcement')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeColor = isDarkMode ? Colors.black : Colors.white;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [themeColor.withOpacity(0.9), themeColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Announcement Name',
                          border: const OutlineInputBorder(),
                          prefixIcon: PhosphorIcon(PhosphorIcons.speakerHigh()),
                        ),
                      ).animate().slideX(duration: 500.ms),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: const OutlineInputBorder(),
                          prefixIcon: PhosphorIcon(PhosphorIcons.note()),
                        ),
                        maxLines: 3,
                      ).animate().slideX(duration: 600.ms),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _typeController,
                        decoration: InputDecoration(
                          labelText: 'Type',
                          border: OutlineInputBorder(),
                          prefixIcon: PhosphorIcon(PhosphorIcons.tag()),
                        ),
                      ).animate().slideX(duration: 700.ms),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: addAnnouncement,
                        icon: PhosphorIcon(PhosphorIcons.plusCircle()),
                        label: const Text('Add Announcement'),
                      ).animate().fadeIn(duration: 800.ms),
                      const SizedBox(height: 20),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator()).animate().fadeIn(duration: 500.ms)
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _announcements.length,
                              itemBuilder: (context, index) {
                                final announcement = _announcements[index];
                                return Card(
                                  color: themeColor.withOpacity(0.9),
                                  margin: const EdgeInsets.all(8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      announcement['Name'] ?? '',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(announcement['Description'] ?? ''),
                                    trailing: IconButton(
                                      icon: PhosphorIcon(PhosphorIcons.trash()),
                                      onPressed: _isLoading ? null : () => deleteAnnouncement(announcement['id']),
                                      color: Colors.red,
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