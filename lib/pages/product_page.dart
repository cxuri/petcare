import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductPage extends StatefulWidget {
  final String name;
  final String description;
  final double price;
  final String productType;
  final String size;
  final String ageGroup;
  final String additionalInfo;
  int stock;
  final List<String> suitableTypes;
  final String productId;
  final String? imageUrl;

  ProductPage({
    required this.name,
    required this.description,
    required this.price,
    required this.productType,
    required this.size,
    required this.ageGroup,
    required this.additionalInfo,
    required this.stock,
    required this.suitableTypes,
    required this.productId,
    this.imageUrl,
  });

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  static const Color accentColor = Color(0xFFFEBD69); // Amazon yellow
  static const Color textColor = Colors.black;

  String? _userId;
  int _selectedQuantity = 1;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  void _fetchUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _userId = user?.uid;
    });
  }

  void _placeOrder(BuildContext context) async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in to place an order.")),
      );
      return;
    }

    bool confirm = await _showConfirmationDialog(context);
    if (!confirm) return;

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference productRef = firestore.collection("products").doc(widget.productId);

      await firestore.runTransaction((transaction) async {
        DocumentSnapshot productSnapshot = await transaction.get(productRef);

        int currentStock = productSnapshot["stock"];

        if (currentStock < _selectedQuantity) {
          throw Exception("Not enough stock available!");
        }

        transaction.update(productRef, {"stock": currentStock - _selectedQuantity});

        transaction.set(firestore.collection("orders").doc(), {
          "product_id": widget.productId,
          "user_id": _userId,
          "quantity": _selectedQuantity,
          "total_price": widget.price * _selectedQuantity,
          "status": "Pending",
        });
      });

      setState(() {
        widget.stock -= _selectedQuantity;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order placed successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to place order: ${e.toString()}")),
      );
    }
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirm Order", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              content: Text("Are you sure you want to place this order?", style: GoogleFonts.poppins()),
              actions: [
                TextButton(
                  child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.red)),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                  child: Text("Confirm", style: GoogleFonts.poppins(color: Colors.black)),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.name, style: GoogleFonts.poppins(fontSize: 20, color: textColor)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product Image
            Container(
              height: 300,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: widget.imageUrl != null && widget.imageUrl!.isNotEmpty
                      ? NetworkImage(widget.imageUrl!)
                      : const AssetImage("assets/placeholder.png") as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 8),

                  // Price & Stock Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("\$${widget.price.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.green)),
                      widget.stock > 0
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text("In Stock (${widget.stock} left)", style: GoogleFonts.poppins(color: Colors.green, fontSize: 14)),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text("Out of Stock", style: GoogleFonts.poppins(color: Colors.red, fontSize: 14)),
                            ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Additional Information
                  _buildInfoRow("Category:", widget.productType),
                  _buildInfoRow("Size:", widget.size),
                  _buildInfoRow("Age Group:", widget.ageGroup),
                  _buildInfoRow("Additional Info:", widget.additionalInfo),

                  const Divider(height: 30, thickness: 1, color: Colors.grey),

                  // Suitable Types
                  Text("Suitable For:", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.suitableTypes.map((type) {
                      return Chip(
                        label: Text(type, style: GoogleFonts.poppins(fontSize: 14)),
                        backgroundColor: Colors.blue.shade100,
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Order Button
                  widget.stock > 0
                      ? SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => _placeOrder(context),
                            child: Text("Buy Now", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$title ", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
          Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87))),
        ],
      ),
    );
  }
}
