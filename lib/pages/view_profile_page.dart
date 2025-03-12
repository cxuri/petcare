import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petcare/pages/profile/update_user.dart';
import 'pet_profile_page.dart';
import 'update_profile_page.dart';

class ViewProfilePage extends StatefulWidget {
  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _deleteProfile(String docId) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('pet_profiles')
          .doc(docId)
          .delete();
    }
  }

  void _bookAppointment(String petName) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Booking appointment for $petName')));
  }

  void _updateProfile(String docId) async {
      final User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot pet = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('pet_profiles')
            .doc(docId)
            .get();

        if (pet.exists) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdatePetProfilePage(petId: docId),
            ),
          );
        }
      }
    }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    if (user == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: Center(
          child: Text(
            'User not logged in.',
            style: GoogleFonts.lato(fontSize: 16, color: Colors.white70),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PetProfilePage()),
          );
        },
        backgroundColor: Colors.tealAccent,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pet Profiles',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    _firestore
                        .collection('users')
                        .doc(user.uid)
                        .collection('pet_profiles')
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.tealAccent,
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No profiles found.',
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      var data = doc.data() as Map<String, dynamic>;

                      return Card(
                        color: const Color(0xFF1E1E1E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'] ?? 'Unknown',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Species: ${data['species'] ?? 'Unknown'}',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                'Weight: ${data['weight'] ?? 'Unknown'} kg',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              Text(
                                'Age: ${data['age'] ?? 'Unknown'} years',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Other Info:',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                data['other_info'] ?? 'No additional info',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _updateProfile(doc.id),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Update',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _deleteProfile(doc.id),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
