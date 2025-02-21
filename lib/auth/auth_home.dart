import 'package:flutter/material.dart';
import 'package:petcare/auth/login_screen.dart';
import 'package:petcare/auth/register_screen.dart';

class AuthHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.center, // Align horizontally in center
          children: [
            // Title
            Text(
              'Welcome to PetCare App!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.orange, // Set title color to orange
                fontFamily: 'Arial', // Set font to Arial or a more suitable one
              ),
            ),
            SizedBox(height: 20),

            // Description Text
            Text(
              'Your companion for taking care of your pets.\nSign in or register to get started.',
              textAlign: TextAlign.center, // Center the description
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54, // Set description color to dark gray
                fontFamily: 'Arial',
              ),
            ),
            SizedBox(height: 40),

            // Login Button (non-outlined, with border radius and enough size)
            Container(
              width:
                  double.infinity, // Make button width span across the screen
              height: 50, // Set enough height
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Background color for button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Border radius
                  ),
                  textStyle: TextStyle(
                    fontSize: 18,
                  ), // Font size of button text
                ),
                onPressed: () {
                  // Navigate to Login Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text('Login'),
              ),
            ),
            SizedBox(height: 20),

            // Register Button (outlined with same specs)
            Container(
              width:
                  double.infinity, // Make button width span across the screen
              height: 50, // Set enough height
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.orange), // Border color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Border radius
                  ),
                  textStyle: TextStyle(
                    fontSize: 18,
                  ), // Font size of button text
                ),
                onPressed: () {
                  // Navigate to Register Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text('Register', style: TextStyle(color: Colors.orange)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
