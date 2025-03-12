import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:petcare/auth/auth_home.dart';
import 'package:petcare/auth/login_screen.dart';
import 'package:petcare/auth/register_screen.dart';
import 'package:petcare/pages/home_page.dart';
import 'package:petcare/pages/pet_profile_page.dart';
import 'package:petcare/pages/view_profile_page.dart';
import 'package:petcare/pages/profile/create_user.dart';
import 'package:petcare/pages/profile/profile.dart';
import 'package:petcare/pages/profile/update_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<String> _getInitialRoute() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return '/auth'; // Redirect to login if user is not signed in
    } else {
      return '/home';
    }


  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        // Ensure we have a valid initial route
        String initialRoute = snapshot.data ?? '/auth';

        return MaterialApp(
          title: 'PetCare App',
          theme: ThemeData(primarySwatch: Colors.blue),
          onGenerateRoute: (settings) {
            return _generateRoute(settings);
          },
          home: _getHomeScreen(initialRoute),
        );
      },
    );
  }

  /// Generates routes dynamically to prevent null issues
  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/auth':
        return MaterialPageRoute(builder: (_) => AuthHome());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => PetProfilePage());
      case '/vprofile':
        return MaterialPageRoute(builder: (_) => ViewProfilePage());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeTab());
      case '/create_user':
        return MaterialPageRoute(builder: (_) => CreateUserProfilePage());
      default:
        return MaterialPageRoute(builder: (_) => AuthHome());
    }
  }

  /// Ensures the home screen is correctly set based on initial route
  Widget _getHomeScreen(String route) {
    switch (route) {
      case '/home':
        return HomeTab();
      case '/create_user':
        return CreateUserProfilePage();
      default:
        return AuthHome();
    }
  }
}
