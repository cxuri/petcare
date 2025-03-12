import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateUserProfilePage extends StatefulWidget {
  const CreateUserProfilePage({super.key});

  @override
  _CreateUserProfilePageState createState() => _CreateUserProfilePageState();
}

class _CreateUserProfilePageState extends State<CreateUserProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _billingAddressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      String userId = user.uid;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("user_profile")
          .doc("profile")
          .set({
        "full_name": _fullNameController.text.trim(),
        "billing_address": _billingAddressController.text.trim(),
        "phone": _phoneController.text.trim(),
        "created_at": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile Created Successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Card(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Create Profile",
                        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildTextField("Full Name", _fullNameController, Icons.person, TextInputType.name),
                    const SizedBox(height: 15),
                    _buildTextField("Billing Address", _billingAddressController, Icons.location_on, TextInputType.streetAddress),
                    const SizedBox(height: 15),
                    _buildTextField("Phone Number", _phoneController, Icons.phone, TextInputType.phone),
                    const SizedBox(height: 30),

                    Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.orangeAccent)
                          : ElevatedButton(
                              onPressed: _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text("Create Profile", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, TextInputType keyboardType) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: Colors.orangeAccent),
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: (value) => value!.isEmpty ? "Please enter $label" : null,
    );
  }
}
