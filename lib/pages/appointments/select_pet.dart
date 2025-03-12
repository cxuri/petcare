import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'select_appointment.dart';

class SelectPetPage extends StatefulWidget {
  final String userId;

  const SelectPetPage({
    super.key,
    required this.userId,
  });

  @override
  _SelectPetPageState createState() => _SelectPetPageState();
}

class _SelectPetPageState extends State<SelectPetPage> {
  List<Map<String, dynamic>> _pets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPets();
  }

  Future<void> _fetchPets() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('pet_profiles')
        .get();

    setState(() {
      _pets = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background for better contrast
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Select Your Pet",
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? _buildLoadingShimmer()
                  : _pets.isEmpty
                      ? _buildNoPetsFound()
                      : ListView.builder(
                          itemCount: _pets.length,
                          itemBuilder: (context, index) {
                            var pet = _pets[index];
                            return _buildPetCard(pet);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Container(width: 40, height: 40, color: Colors.grey[300]),
            title: Container(height: 16, color: Colors.grey[300]),
            subtitle: Container(height: 12, color: Colors.grey[200]),
          ),
        );
      },
    );
  }

  Widget _buildNoPetsFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets, size: 80, color: Colors.orangeAccent),
          const SizedBox(height: 10),
          Text(
            "No pets found",
            style: GoogleFonts.poppins(fontSize: 20, color: Colors.black),
          ),
          const SizedBox(height: 5),
          Text(
            "Add a pet profile to continue",
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildPetCard(Map<String, dynamic> pet) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.orangeAccent,
          child: Icon(Icons.pets, color: Colors.white, size: 30),
        ),
        title: Text(
          pet['name'],
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Breed: ${pet['breed']}",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              "Age: ${pet['age'] ?? 'N/A'} years | Weight: ${pet['weight'] ?? 'N/A'} kg",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.black54, size: 18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectAppointmentTypePage(
                userId: widget.userId,
                petId: pet['id'],
                petName: pet['name'],
              ),
            ),
          );
        },
      ),
    );
  }
}
