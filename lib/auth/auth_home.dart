import 'package:flutter/material.dart';
import 'package:petcare/auth/login_screen.dart';
import 'package:petcare/auth/register_screen.dart';

class AuthHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade300, Colors.orange.shade600],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Pet Icon
              Icon(
                Icons.pets,
                size: 100,
                color: Colors.white,
              ),
              SizedBox(height: 20),

              // Title
              Text(
                'Welcome to PetCare!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Arial',
                ),
              ),
              SizedBox(height: 10),

              // Description
              Text(
                'Your companion for taking care of your pets.\nSign in or register to get started.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 40),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.orange.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Login'),
                ),
              ),
              SizedBox(height: 20),

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
