import 'package:flutter/material.dart';
import 'package:petcare/services/auth_service.dart';
import 'package:petcare/pages/home_page.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome Back to PetCare',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 40),

            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.email, color: Colors.orangeAccent),
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.lock, color: Colors.orangeAccent),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: Size(double.infinity, 50),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                String email = _emailController.text;
                String password = _passwordController.text;

                final userCredential = await _authService.signInWithEmailPassword(email, password);
                if (userCredential != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeTab()),
                  );
                } else {
                  _showErrorDialog(context, 'Login failed');
                }
              },
              child: Text('Sign In', style: TextStyle(color: Colors.black)),
            ),

            SizedBox(height: 20),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.orangeAccent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: Size(double.infinity, 50),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                final userCredential = await _authService.signInWithGoogle();
                if (userCredential != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeTab()),
                  );
                } else {
                  _showErrorDialog(context, 'Google sign-in failed');
                }
              },
              child: Text('Sign In with Google', style: TextStyle(color: Colors.orangeAccent)),
            ),

            SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/auth');
              },
              child: Text('Back to Home', style: TextStyle(color: Colors.orangeAccent)),
            ),
          ],
        ),
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
