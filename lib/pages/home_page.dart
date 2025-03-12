import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petcare/pages/shop_page.dart';
import 'package:petcare/pages/view_profile_page.dart';
import 'orders_appointments.dart';
import 'appointments/select_pet.dart';
import 'profile/profile.dart';
import 'profile/create_user.dart';

class HomeTab extends StatefulWidget {
  static const Color cardColor = Color(0xFF1E1E1E);
  static const Color backgroundColor = Color(0xFF121212);
  static const Color textColor = Colors.white;

  const HomeTab({Key? key}) : super(key: key);

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final User? user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 0;

  Future<bool> _checkUserProfile() async {
    if (user == null) return false;
    DocumentSnapshot userProfile = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('user_profile')
        .doc('profile')
        .get();
    return userProfile.exists;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Just update index instead of navigating
    });
  }

  // List of pages to switch between dynamically
  final List<Widget> _pages = [
    HomePageContent(),      // Home page
    ViewProfilePage(),      // Pets page
    MyOrdersPage(),        // Orders page
    AppointmentsPage(),    // Appointments page
    UserProfilePage(),     // Profile page
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: HomeTab.backgroundColor),
      backgroundColor: HomeTab.backgroundColor,
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E1E), // Dark grey for better contrast
        selectedItemColor: Colors.cyanAccent, // Bright color for visibility
        unselectedItemColor: Colors.white70, // Light grey for readability
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Ensures all labels are visible
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: "Pets"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Appointments"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// Extract Home Page Content as a Separate Widget
class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _HomeTabState()._checkUserProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        bool profileExists = snapshot.data ?? false;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                "Welcome!",
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: HomeTab.textColor),
              ),
              const SizedBox(height: 20),
              if (!profileExists)
                _buildCard(
                  context,
                  title: "Complete Your Profile",
                  description: "Update your details to access full features.",
                  icon: Icons.warning_amber_rounded,
                  iconColor: Colors.redAccent,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateUserProfilePage()),
                  ),
                ),
              const SizedBox(height: 16),
              _buildCard(
                context,
                title: "Book Appointments",
                description: "Schedule grooming, vet visits, and more",
                icon: Icons.event,
                iconColor: const Color(0xFF5AA9E6),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectPetPage(userId: FirebaseAuth.instance.currentUser!.uid)),
                ),
              ),
              const SizedBox(height: 16),
              _buildCard(
                context,
                title: "Shop for Products",
                description: "Buy pet food, toys, accessories, and more",
                icon: Icons.shopping_bag,
                iconColor: const Color(0xFF71C562),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ShopPage())),
              ),
              const SizedBox(height: 16),
              _buildCard(
                context,
                title: "My Pets",
                description: "View and manage your pet profiles",
                icon: Icons.pets,
                iconColor: const Color(0xFFF4A261),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProfilePage())),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title, required String description, required IconData icon, required Color iconColor, required VoidCallback onTap}) {
    return Card(
      color: HomeTab.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        leading: Icon(icon, color: iconColor, size: 32),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: HomeTab.textColor)),
        subtitle: Text(description, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54),
        onTap: onTap,
      ),
    );
  }
}
