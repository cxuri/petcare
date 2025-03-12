import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetProfilePage extends StatefulWidget {
  @override
  _PetProfilePageState createState() => _PetProfilePageState();
}

class _PetProfilePageState extends State<PetProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    if (_nameController.text.isEmpty || _breedController.text.isEmpty || _weightController.text.isEmpty || _ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Generate a unique document ID
    DocumentReference petDocRef = _firestore.collection('users')
        .doc(user.uid)
        .collection('pet_profiles')
        .doc(); // Generates a unique ID

    await petDocRef.set({
      'pet_id': petDocRef.id, // Store the generated pet ID
      'name': _nameController.text,
      'breed': _breedController.text,
      'weight': _weightController.text,
      'age': _ageController.text,
      'other_info': _infoController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile Created Successfully')),
    );
    _clearFields();
  }


  void _clearFields() {
    _nameController.clear();
    _breedController.clear();
    _weightController.clear();
    _ageController.clear();
    _infoController.clear();
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: Text('Create Pet Profile', style: GoogleFonts.poppins(fontSize: 20, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                backgroundColor: Color(0xFF1E1E1E),
                child: _image == null ? Icon(Icons.camera_alt, size: 60, color: Color(0xFFD17842)) : null,
              ),
            ),
            SizedBox(height: 20),
            Card(
              color: Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildTextField(_nameController, 'Pet Name'),
                    _buildTextField(_breedController, 'Breed'),
                    _buildTextField(_weightController, 'Weight (kg)', isNumber: true),
                    _buildTextField(_ageController, 'Age (years)', isNumber: true),
                    _buildTextField(_infoController, 'Other Information'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Color(0xFFD17842),
                foregroundColor: Colors.white,
                elevation: 6,
              ),
              child: Text('Save Profile', style: GoogleFonts.poppins(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[500]),
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
