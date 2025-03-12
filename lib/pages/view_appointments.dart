import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewAppointments extends StatefulWidget {
  @override
  _ViewAppointmentsState createState() => _ViewAppointmentsState();
}

class _ViewAppointmentsState extends State<ViewAppointments> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  void _fetchUserId() {
    User? user = _auth.currentUser;
    setState(() {
      _userId = user?.uid;
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("My Appointments", style: GoogleFonts.poppins(fontSize: 22)),
        backgroundColor: Colors.grey[900],
      ),
      body: _userId == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('appointments').where('userId', isEqualTo: _userId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No Appointments Found", style: GoogleFonts.poppins(color: Colors.white)));
                }

                var appointments = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    var appointment = appointments[index];
                    return Card(
                      color: Colors.grey[850],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 6,
                      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Doctor: ${appointment["doctor_name"]}",
                                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(appointment["status"]),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    appointment["status"],
                                    style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Date: ${appointment["date"]}",
                              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
                            ),
                            Text(
                              "Time: ${appointment["time"]}",
                              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70),
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    onPressed: () async {
                                      await _firestore.collection('appointments').doc(appointment.id).delete();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Appointment Cancelled!")));
                                    },
                                    child: Text("Cancel", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                                  ),
                                ),
                                SizedBox(width: 12),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.white, size: 28),
                                  onPressed: () async {
                                    await _firestore.collection('appointments').doc(appointment.id).delete();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Appointment Deleted!")));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
