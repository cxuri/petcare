import 'package:flutter/material.dart';
import 'package:petcare/services/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Welcome Text
            Text(
              'Create a New Account!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 30),

            // Email Field
            _buildTextField(_emailController, Icons.email, 'Email'),
            SizedBox(height: 20),

            // Password Field
            _buildTextField(_passwordController, Icons.lock, 'Password', isPassword: true),
            SizedBox(height: 20),

            // Confirm Password Field
            _buildTextField(_confirmPasswordController, Icons.lock_outline, 'Confirm Password', isPassword: true),
            SizedBox(height: 30),

            // Sign Up Button
            _buildButton('Sign Up', Colors.orange, Colors.black, () async {
              String email = _emailController.text;
              String password = _passwordController.text;
              String confirmPassword = _confirmPasswordController.text;

              if (password != confirmPassword) {
                _showErrorDialog(context, 'Passwords do not match!');
                return;
              }

              final userCredential = await _authService.signUpWithEmailPassword(email, password);
              if (userCredential != null) {
                print('User registered as: ${userCredential.user?.email}');
              } else {
                _showErrorDialog(context, 'Sign up failed');
              }
            }),
            SizedBox(height: 20),

            // Google Sign Up Button
            _buildButton('Sign Up with Google', Colors.white, Colors.orange, () async {
              final userCredential = await _authService.signInWithGoogle();
              if (userCredential != null) {
                print('User signed up with Google: ${userCredential.user?.email}');
              } else {
                _showErrorDialog(context, 'Google sign-up failed');
              }
            }),
            SizedBox(height: 20),

            // Back to Home
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Back to Home', style: TextStyle(color: Colors.orange, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, IconData icon, String hint, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        prefixIcon: Icon(icon, color: Colors.orange),
      ),
    );
  }

  Widget _buildButton(String text, Color textColor, Color bgColor, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: textColor)),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
