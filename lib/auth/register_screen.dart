import 'package:flutter/material.dart';
import 'package:petcare/services/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.center, // Align content in the center
          children: [
            // Welcome text
            Text(
              'Create a new account!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.orange, // Warm color (orange)
                fontFamily: 'Arial', // Set font to Arial
              ),
            ),
            SizedBox(height: 20),

            // Email field
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.orange), // Label color
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange,
                  ), // Border color on focus
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
                  borderSide: BorderSide(
                    color: Colors.orange,
                  ), // Border color on focus
                ),
              ),
            ),
            SizedBox(height: 20),

            // Confirm Password field
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: TextStyle(color: Colors.orange), // Label color
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.orange,
                  ), // Border color on focus
                ),
              ),
            ),
            SizedBox(height: 20),

            // Sign Up button (non-outlined, with border radius and enough size)
            Container(
              width:
                  double.infinity, // Make button width span across the screen
              height: 50, // Set enough height
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
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  String confirmPassword = _confirmPasswordController.text;

                  if (password != confirmPassword) {
                    // Passwords don't match
                    print('Passwords do not match!');
                    return;
                  }

                  final userCredential = await _authService
                      .signUpWithEmailPassword(email, password);

                  if (userCredential != null) {
                    print('User registered as: ${userCredential.user?.email}');
                    // Navigate to another screen, like the home screen
                  } else {
                    print('Sign up failed');
                    // Show error to the user
                  }
                },
                child: Text('Sign Up'),
              ),
            ),

            SizedBox(height: 20),

            // Google Sign Up button (outlined, with border radius and enough size)
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
                  ), // Font size for button text
                ),
                onPressed: () async {
                  final userCredential = await _authService.signInWithGoogle();

                  if (userCredential != null) {
                    print(
                      'User signed up with Google: ${userCredential.user?.email}',
                    );
                    // Navigate to the home screen after successful registration
                  } else {
                    print('Google sign-up failed');
                    // Show error to the user
                  }
                },
                child: Text(
                  'Sign Up with Google',
                  style: TextStyle(color: Colors.orange), // Button text color
                ),
              ),
            ),

            SizedBox(height: 20),

            // Back to home screen button
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
}
