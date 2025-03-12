import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Collection reference for pet profiles
  final CollectionReference petProfiles = FirebaseFirestore.instance.collection(
    'pet_profiles',
  );

  // Upload image to Firebase Storage and return the download URL
  Future<String?> _uploadImage(File image) async {
    try {
      // Create a unique file name using the current timestamp
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // Reference to Firebase Storage
      Reference ref = FirebaseStorage.instance
          .ref()
          .child("pet_images")
          .child(fileName);
      UploadTask uploadTask = ref.putFile(image);

      // Wait for the task to complete and get the download URL
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // Save the pet profile to Firestore
  Future<void> savePetProfile(
    String name,
    String age,
    String breed,
    File? image,
  ) async {
    try {
      String? imageUrl = image != null ? await _uploadImage(image) : null;

      // Get the current user's UID (User ID) from FirebaseAuth
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Create a new document in Firestore with the user's UID
        await petProfiles.add({
          'name': name,
          'age': age,
          'breed': breed,
          'imageUrl': imageUrl,
          'userId': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print("Pet profile saved successfully.");
      } else {
        print("No user is logged in.");
      }
    } catch (e) {
      print("Error saving pet profile: $e");
    }
  }

  // Load the pet profile for the current user
  Future<Map<String, dynamic>?> loadPetProfile() async {
    try {
      // Get the current user's UID (User ID) from FirebaseAuth
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Query Firestore for the pet profile based on userId
        QuerySnapshot querySnapshot =
            await petProfiles
                .where('userId', isEqualTo: user.uid)
                .limit(1) // Assuming there's only one pet profile per user
                .get();

        // If there's a pet profile for the user
        if (querySnapshot.docs.isNotEmpty) {
          // Return the data of the first pet profile found
          return querySnapshot.docs.first.data() as Map<String, dynamic>;
        } else {
          print("No pet profile found for this user.");
          return null;
        }
      } else {
        print("No user is logged in.");
        return null;
      }
    } catch (e) {
      print("Error loading pet profile: $e");
      return null;
    }
  }
}
