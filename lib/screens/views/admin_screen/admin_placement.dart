import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Placement_Update extends StatefulWidget {
  const Placement_Update({super.key});

  @override
  State<Placement_Update> createState() => _Placement_UpdateState();
}

class _Placement_UpdateState extends State<Placement_Update> {
  final TextEditingController _PlacementNameController = TextEditingController();
  final TextEditingController _PlacementLPAController = TextEditingController();
  final TextEditingController _PlacementCompanyController = TextEditingController();
  bool _isLoggedIn = false;
  bool _isLoading = false;
  List<Map<String, dynamic>> _placements = [];

  
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
  
  Future<void> deleteEvent(String placementId) async {
    try {
      await Supabase.instance.client
          .from('Placement')
          .delete()
          .eq('Placement_Id', placementId);
      setState(() {
        _placements.removeWhere((placement) => placement['Placement_Id'] == placementId);
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
      final data = await Supabase.instance.client
          .from('Placement')
          .select('*');

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
      final PlacementData = {
        'Name': _PlacementNameController.text,
        'LPA': _PlacementLPAController.text,
        'Company_Name': _PlacementCompanyController.text,
        //'Start_date': DateTime.now().toIso8601String(),
        'Uploaded_by': Supabase.instance.client.auth.currentUser!.id,
      };

      final response = await Supabase.instance.client
          .from('Placement')
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
                                      deleteEvent(placement['Placement_Id']);
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
