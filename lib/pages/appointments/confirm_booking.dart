import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmBookingPage extends StatelessWidget {
  final String userId;
  final String petId;
  final String appointmentType;
  final String date;
  final String petName;

  const ConfirmBookingPage({
    super.key,
    required this.userId,
    required this.petId,
    required this.appointmentType,
    required this.date,
    required this.petName,
  });

  Future<void> _confirmBooking(BuildContext context) async {
    await FirebaseFirestore.instance.collection('appointments').add({
      'userId': userId,
      'name': petName,
      'petId': petId,
      'type': appointmentType,
      'date': date,
      'status': 'Pending',
    });

    // Show success pop-up
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.check_circle, color: Colors.green, size: 50),
        content: Text(
          "Your appointment has been confirmed!",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                "OK",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Appointment Details",
              style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            _buildDetailCard("Pet Name", petName, Icons.pets),
            const SizedBox(height: 12),
            _buildDetailCard("Appointment Type", appointmentType, Icons.event),
            const SizedBox(height: 12),
            _buildDetailCard("Date", date, Icons.calendar_today),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _confirmBooking(context),
                icon: const Icon(Icons.check, color: Colors.black),
                label: Text(
                  "Confirm Appointment",
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String value, IconData icon) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.orangeAccent, size: 28),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey)),
        subtitle: Text(value, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white)),
      ),
    );
  }
}
