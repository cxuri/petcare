import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petcare/services/auth_service.dart'; // Import AuthService for sign-out

class HomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService(); // Instance of AuthService

  @override
  Widget build(BuildContext context) {
    final User? user =
        FirebaseAuth.instance.currentUser; // Get the current user

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.orange, // AppBar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Center the content
          children: [
            // Welcome message
            Text(
              'Welcome, ${user?.email ?? "Guest"}!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.orange, // Warm orange color for text
                fontFamily: 'Arial', // Set font to Arial for a clean look
              ),
            ),
            SizedBox(height: 40),

            // Description text (optional)
            Text(
              'Thank you for using PetCare. Explore our app and take care of your pets!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54, // Subtle dark color for the description
              ),
              textAlign: TextAlign.center, // Center align the text
            ),
            SizedBox(height: 40),

            // Logout button (non-outlined, with border radius and enough size)
            Container(
              width:
                  double.infinity, // Make button width span across the screen
              height: 50, // Set enough height for button
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  textStyle: TextStyle(
                    fontSize: 18,
                  ), // Font size for button text
                ),
                onPressed: () async {
                  // Sign out using the AuthService
                  await _authService.signOut();
                  // After signing out, navigate to the login screen or auth home
                  Navigator.pushReplacementNamed(context, '/auth');
                },
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                  ), // Text color (white for contrast)
                ),
              ),
            ),
            SizedBox(height: 20),

            // Optional additional buttons or content can be added here, if needed
          ],
        ),
      ),
    );
  }
}
