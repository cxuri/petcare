import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petcare/pages/product_page.dart';

class ShopPage extends StatefulWidget {
  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userId;
  List<DocumentSnapshot> _products = [];
  String _searchQuery = "";
  String _selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    _fetchProducts();
  }

  void _fetchUserId() {
    User? user = _auth.currentUser;
    setState(() {
      _userId = user?.uid;
    });
  }

  void _fetchProducts() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('products').get();
      setState(() {
        _products = snapshot.docs;
      });
    } catch (e) {
      debugPrint("Error fetching products: $e");
    }
  }

  void _searchProducts(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _filterProducts(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DocumentSnapshot> filteredProducts = _products.where((product) {
      String name = product["name"].toString().toLowerCase();
      String type = product["product_type"].toString();
      return name.contains(_searchQuery) && (_selectedFilter == "All" || type == _selectedFilter);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text("Shop", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _searchProducts,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                labelText: "Search Products",
                labelStyle: GoogleFonts.poppins(color: Colors.white70),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
              ),
            ),
          ),
          DropdownButton<String>(
            dropdownColor: Colors.grey[800],
            value: _selectedFilter,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
            items: ["All", "Collar", "Leash", "Bed", "Toy", "Grooming", "Other"].map((String category) {
              return DropdownMenuItem(value: category, child: Text(category));
            }).toList(),
            onChanged: (value) {
              _filterProducts(value!);
            },
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                var product = filteredProducts[index];
                return _buildProductCard(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(DocumentSnapshot product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(
              name: product["name"],
              additionalInfo: product['additional_info'],
              ageGroup: product['age_group'],
              description: product["description"],
              price: product["price"].toDouble(),
              productType: product["product_type"],
              size: product["size"],
              stock: product["stock"],
              suitableTypes: List<String>.from(product["suitable_types"] ?? []),
              productId: product.id,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.grey[850],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product["name"],
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                "${product["product_type"]} - ${product["size"]}",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 5),
              Text(
                "\$${product["price"]}",
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              const SizedBox(height: 5),
              Text(
                "Stock: ${product["stock"]}",
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.greenAccent),
              ),
              const SizedBox(height: 5),
              Text(
                "Suitable for: ${List<String>.from(product["suitable_types"] ?? []).join(", ")}",
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _addToCart(product.id),
                    icon: const Icon(Icons.shopping_cart, size: 18, color: Colors.white),
                    label: Text("Add", style: GoogleFonts.poppins(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.white70),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductPage(
                            name: product["name"],
                            additionalInfo: product['additional_info'],
                            ageGroup: product['age_group'],
                            description: product["description"],
                            price: product["price"].toDouble(),
                            productType: product["product_type"],
                            size: product["size"],
                            stock: product["stock"],
                            suitableTypes: List<String>.from(product["suitable_types"] ?? []),
                            productId: product.id,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToCart(String productId) async {
    if (_userId == null) return;
    try {
      await _firestore.collection('users').doc(_userId).collection('cart').doc(productId).set({
        "product_id": productId,
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added to cart!")));
    } catch (e) {
      debugPrint("Error adding to cart: $e");
    }
  }
}
