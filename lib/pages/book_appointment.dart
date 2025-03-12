import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BookAppointmentPage extends StatefulWidget {
  final String userId;

  const BookAppointmentPage({super.key, required this.userId});

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  String _appointmentType = "Sitting";
  String? _selectedDog;
  List<String> _dogNames = [];

  @override
  void initState() {
    super.initState();
    _fetchDogs();
  }

  Future<void> _fetchDogs() async {
    QuerySnapshot dogsSnapshot = await _firestore
        .collection('users')
        .doc(widget.userId)
        .collection('pet_profiles')
        .get();

    setState(() {
      _dogNames = dogsSnapshot.docs.map((doc) => doc["name"] as String).toList();
      if (_dogNames.isNotEmpty) {
        _selectedDog = _dogNames.first;
      }
    });
  }

  Future<void> _bookAppointment() async {
    if (_dateController.text.isEmpty || _detailsController.text.isEmpty || _selectedDog == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }
    await _firestore.collection('appointments').add({
      'date': _dateController.text,
      'details': _detailsController.text,
      'userId': widget.userId,
      'pet_name': _selectedDog,
      'status': 'Pending',
      'type': _appointmentType,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Appointment Booked!")),
    );
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Book an Appointment', style: GoogleFonts.poppins(fontSize: 20, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Schedule an Appointment",
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 20),
            if (_dogNames.isNotEmpty)
              DropdownButtonFormField(
                value: _selectedDog,
                items: _dogNames.map((String item) {
                  return DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(color: Colors.black)));
                }).toList(),
                onChanged: (value) => setState(() => _selectedDog = value.toString()),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              )
            else
              const Text("No pets found. Please create a profile first.",
                  style: TextStyle(color: Colors.red, fontSize: 16)),
            const SizedBox(height: 20),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                labelText: "Appointment Date",
                labelStyle: const TextStyle(color: Colors.grey),
                suffixIcon: const Icon(Icons.calendar_today, color: Colors.orangeAccent),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _detailsController,
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                labelText: "Details",
                labelStyle: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              value: _appointmentType,
              items: ["Sitting", "Training", "Grooming", "Veterinarian"].map((String item) {
                return DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(color: Colors.black)));
              }).toList(),
              onChanged: (value) => setState(() => _appointmentType = value.toString()),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                labelText: "Appointment Type",
                labelStyle: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _bookAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Confirm Appointment",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
