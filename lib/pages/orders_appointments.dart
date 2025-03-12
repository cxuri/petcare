import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  _MyOrdersPageState createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String? userId = _auth.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark mode background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text("My Orders", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: userId == null
            ? const Center(
                child: Text("User not logged in", style: TextStyle(color: Colors.white70, fontSize: 16)),
              )
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('orders').where('user_id', isEqualTo: userId).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.tealAccent));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No orders found", style: TextStyle(color: Colors.white70, fontSize: 16)),
                    );
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var order = snapshot.data!.docs[index];
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance.collection('products').doc(order['product_id']).get(),
                        builder: (context, productSnapshot) {
                          if (!productSnapshot.hasData) {
                            return const SizedBox();
                          }
                          var product = productSnapshot.data!;
                          return Card(
                            color: const Color(0xFF1E1E1E), // Dark gray card
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.tealAccent,
                                child: Text(
                                  product['name'][0],
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ),
                              title: Text(
                                product['name'],
                                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Quantity: ${order['quantity']}", style: GoogleFonts.poppins(color: Colors.white70)),
                                  Text("Total Price: \$${order['total_price']}", style: GoogleFonts.poppins(color: Colors.white70)),
                                  Text("Status: ${order['status']}", style: GoogleFonts.poppins(color: Colors.tealAccent)),
                                ],
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.tealAccent),
                              onTap: () {
                                // Navigate to order details page (if needed)
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}



class AppointmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No appointments scheduled',
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
              ),
            );
          }
          var appointments = snapshot.data!.docs;
          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              var appointment = appointments[index];
              var data = appointment.data() as Map<String, dynamic>;

              Color statusColor;
              switch (data['status']) {
                case 'Pending':
                  statusColor = Colors.orange;
                  break;
                case 'Confirmed':
                  statusColor = Colors.green;
                  break;
                case 'Cancelled':
                  statusColor = Colors.red;
                  break;
                default:
                  statusColor = Colors.white;
              }

              return Card(
                color: Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Type: ${data['type'] ?? 'Unknown'}',
                        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Pet Name: ${data['name'] ?? 'N/A'}',
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Date: ${data['date'] ?? 'TBD'}',
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Details: ${data['details'] ?? 'No details provided'}',
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Status: ${data['status'] ?? 'Pending'}',
                        style: GoogleFonts.poppins(fontSize: 16, color: statusColor),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              FirebaseFirestore.instance.collection('appointments').doc(appointment.id).update({'status': 'Cancelled'});
                            },
                            child: Text('Cancel Appointment', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.grey),
                            onPressed: () {
                              FirebaseFirestore.instance.collection('appointments').doc(appointment.id).delete();
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
