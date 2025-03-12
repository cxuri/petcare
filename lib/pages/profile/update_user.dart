import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile.dart';

class UpdateUserProfilePage extends StatefulWidget {
  const UpdateUserProfilePage({super.key});

  @override
  _UpdateUserProfilePageState createState() => _UpdateUserProfilePageState();
}

class _UpdateUserProfilePageState extends State<UpdateUserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _billingAddressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = true;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("user_profile")
          .doc("profile")
          .get();

      if (profileSnapshot.exists) {
        Map<String, dynamic> data = profileSnapshot.data() as Map<String, dynamic>;
        _fullNameController.text = data["full_name"] ?? "";
        _billingAddressController.text = data["billing_address"] ?? "";
        _phoneController.text = data["phone"] ?? "";
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error fetching profile: ${e.toString()}"),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .collection("user_profile")
          .doc("profile")
          .update({
        "full_name": _fullNameController.text.trim(),
        "billing_address": _billingAddressController.text.trim(),
        "phone": _phoneController.text.trim(),
        "updated_at": Timestamp.now(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserProfilePage()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile Updated Successfully"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: ${e.toString()}"),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.orangeAccent)
            : SingleChildScrollView(
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
                              "Update Profile",
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
                            child: _isUpdating
                                ? const CircularProgressIndicator(color: Colors.orangeAccent)
                                : ElevatedButton(
                                    onPressed: _updateProfile,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orangeAccent,
                                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: Text("Update Profile", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: (value) => value!.isEmpty ? "Please enter $label" : null,
    );
  }
}
