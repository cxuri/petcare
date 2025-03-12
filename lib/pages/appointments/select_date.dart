import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'confirm_booking.dart';

class SelectDatePage extends StatefulWidget {
  final String userId;
  final String petId;
  final String appointmentType;
  final String petName;

  const SelectDatePage({
    super.key,
    required this.userId,
    required this.petId,
    required this.appointmentType,
    required this.petName,
  });

  @override
  _SelectDatePageState createState() => _SelectDatePageState();
}

class _SelectDatePageState extends State<SelectDatePage> {
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.orangeAccent,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _proceed() {
    if (_dateController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmBookingPage(
            userId: widget.userId,
            petId: widget.petId,
            petName: widget.petName,
            appointmentType: widget.appointmentType,
            date: _dateController.text,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please select a date"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.black, // Updated background color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Choose an Appointment Date",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                labelText: "Select Date",
                labelStyle: const TextStyle(color: Colors.white70),
                suffixIcon: const Icon(Icons.calendar_today, color: Colors.orangeAccent),
              ),
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: _proceed,
                icon: const Icon(Icons.arrow_forward, color: Colors.black),
                label: const Text("Next"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
