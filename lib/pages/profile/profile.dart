import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'update_user.dart'; // Import the update profile page
import 'package:google_sign_in/google_sign_in.dart';


class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("user_profile")
          .doc("profile")
          .get();

      if (profileSnapshot.exists) {
        setState(() {
          userData = profileSnapshot.data() as Map<String, dynamic>?;
        });
      }
    }
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut(); // Firebase sign out
      await GoogleSignIn().signOut(); // Google sign out
    } catch (e) {
      print("Error signing out: $e");
    }

    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }


  void _navigateToUpdateProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateUserProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark mode background
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "User Profile",
              style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),

            // Profile Image
            Center(
              child: user?.photoURL != null
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user!.photoURL!),
                    )
                  : const Icon(Icons.person, size: 80, color: Colors.white70),
            ),
            const SizedBox(height: 16),

            // Name
            Center(
              child: Text(
                userData?["full_name"] ?? user!.displayName ?? "Name Not Set",
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),

            // Email
            Center(
              child: Text(
                user!.email ?? "No Email",
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[400]),
              ),
            ),
            const SizedBox(height: 20),

            // Profile Details
            _buildDetailCard("Billing Address", userData?["billing_address"] ?? "Not Set"),
            _buildDetailCard("Phone Number", userData?["phone"] ?? "Not Set"),
            const SizedBox(height: 20),

            // Edit Profile Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _navigateToUpdateProfile,
                icon: const Icon(Icons.edit, color: Colors.white),
                label: Text(
                  "Edit Profile",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Colors.white),
                label: Text(
                  "Logout",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String value) {
    return Card(
      color: const Color(0xFF1E1E1E), // Dark card color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400])),
        subtitle: Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
      ),
    );
  }
}
