import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'select_date.dart';

class SelectAppointmentTypePage extends StatefulWidget {
  final String userId;
  final String petId;
  final String petName;

  const SelectAppointmentTypePage({
    super.key,
    required this.userId,
    required this.petId,
    required this.petName,
  });

  @override
  _SelectAppointmentTypePageState createState() => _SelectAppointmentTypePageState();
}

class _SelectAppointmentTypePageState extends State<SelectAppointmentTypePage> {
  String _selectedType = "Sitting";

  final List<Map<String, dynamic>> _appointmentTypes = [
    {"type": "Sitting", "icon": Icons.home, "color": Colors.blue},
    {"type": "Training", "icon": Icons.school, "color": Colors.green},
    {"type": "Grooming", "icon": Icons.content_cut, "color": Colors.purple},
    {"type": "Veterinarian", "icon": Icons.local_hospital, "color": Colors.red},
  ];

  void _proceed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectDatePage(
          userId: widget.userId,
          petId: widget.petId,
          petName: widget.petName,
          appointmentType: _selectedType,
        ),
      ),
    );
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
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20), // Added extra spacing above heading
            Text(
              "Choose an Appointment Type",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none, // Removed underline
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: _appointmentTypes.length,
                itemBuilder: (context, index) {
                  var type = _appointmentTypes[index];
                  bool isSelected = _selectedType == type["type"];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedType = type["type"];
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected ? type["color"]!.withOpacity(0.8) : Colors.grey[850],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isSelected
                            ? [BoxShadow(color: type["color"]!.withOpacity(0.6), blurRadius: 10)]
                            : [],
                      ),
                      child: Row(
                        children: [
                          Icon(type["icon"], color: Colors.white, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              type["type"],
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                decoration: TextDecoration.none, // Removed underline
                              ),
                            ),
                          ),
                          if (isSelected) const Icon(Icons.check_circle, color: Colors.white),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: _proceed,
                icon: const Icon(Icons.arrow_forward, color: Colors.black),
                label: Text(
                  "Next",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none, // Removed underline
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
