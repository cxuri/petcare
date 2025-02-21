import 'package:flutter/material.dart';
import 'package:petcare/services/auth_service.dart';
import 'package:petcare/pages/home_page.dart'; // Import HomeScreen

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Align content to center
          children: [
            // Welcome back text
            Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.orange, // Warm color (orange)
                fontFamily: 'Arial', // Set font to Arial
              ),
            ),
            SizedBox(height: 20),

            // Username (Email) field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Username (Email)',
                labelStyle: TextStyle(color: Colors.orange), // Label color
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange), // Border color on focus
                ),
              ),
            ),
            SizedBox(height: 20),

            // Password field
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.orange), // Label color
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange), // Border color on focus
                ),
              ),
            ),
            SizedBox(height: 20),

            // Sign In button (non-outlined, with border radius and enough size)
            Container(
              width: double.infinity, // Make button width span across the screen
              height: 50, // Set enough height
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  textStyle: TextStyle(fontSize: 18), // Font size for button text
                ),
                onPressed: () async {
                  String email = _emailController.text;
                  String password = _passwordController.text;

                  final userCredential = await _authService
                      .signInWithEmailPassword(email, password);

                  if (userCredential != null) {
                    print('Logged in as: ${userCredential.user?.email}');
                    // Navigate to the Home screen after login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  } else {
                    print('Login failed');
                    // Show error to the user
                    _showErrorDialog(context, 'Login failed');
                  }
                },
                child: Text('Sign In'),
              ),
            ),

            SizedBox(height: 20),

            // Google Sign In button (outlined, with border radius and enough size)
            Container(
              width: double.infinity, // Make button width span across the screen
              height: 50, // Set enough height
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.orange), // Border color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Border radius
                  ),
                  textStyle: TextStyle(fontSize: 18), // Font size for button text
                ),
                onPressed: () async {
                  final userCredential = await _authService.signInWithGoogle();

                  if (userCredential != null) {
                    print('Logged in as: ${userCredential.user?.email}');
                    // Navigate to the Home screen after Google login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  } else {
                    print('Google sign-in failed');
                    // Show error to the user
                    _showErrorDialog(context, 'Google sign-in failed');
                  }
                },
                child: Text(
                  'Sign In with Google',
                  style: TextStyle(color: Colors.orange), // Button text color
                ),
              ),
            ),

            SizedBox(height: 20),

            // Back to Home screen button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Back to Home',
                style: TextStyle(color: Colors.orange), // Text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to show error messages in a dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
