import 'package:canteen_management_app/homepage.dart';
import 'package:flutter/material.dart';
import 'package:canteen_management_app/components/wishlist_product_card.dart';
import 'package:canteen_management_app/components/bottom_nav_bar.dart';

class WishlistPage extends StatefulWidget {
  final List<Map<String, dynamic>> wishlist;

  const WishlistPage({super.key, required this.wishlist});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late List<Map<String, dynamic>> wishlistItems;

  @override
  void initState() {
    super.initState();
    wishlistItems = List<Map<String, dynamic>>.from(widget.wishlist);
  }

  void removeFromWishlist(int index) {
    final removedItem = wishlistItems[index];
    setState(() {
      wishlistItems.removeAt(index);
    });

    // Show a snackbar (optional)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${removedItem['name']} removed from wishlist")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1, // Adjust based on current screen index
        onTap: (index) {
          // Navigation logic
          switch (index) {
            case 0:
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Homepage()));
              break;
            case 1:
              break;
            case 2:
              Navigator.pushNamed(context, '/order_history');
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search food, drinks...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
              const SizedBox(height: 10),

              // Separator line
              const Divider(thickness: 0.5, color: Colors.grey),
              const SizedBox(height: 10),

              // Wishlist List
              Expanded(
                child: wishlistItems.isEmpty
                    ? const Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 200),
                            Opacity(
                              opacity: 0.5,
                              child: Icon(
                                Icons.warning_amber_outlined,
                                size: 300,
                              )
                            ),
                            const Text(
                              "Your wishlist is empty",
                              style: TextStyle(
                                fontSize: 50, 
                                color: Colors.grey
                              )
                            )
                          ]
                        )
                      )
                    : ListView.builder(
                        itemCount: wishlistItems.length,
                        itemBuilder: (context, index) {
                          final item = wishlistItems[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: WishlistProductCard(
                              name: item['name'],
                              price: item['price'],
                              imagePath: item['imagePath'],
                              category: item['category'],
                              quantity: item['quantity'] is int ? item['quantity'] : int.tryParse(item['quantity'].toString()) ?? 1,
                              onRemove: () {
                                setState(() {
                                  if (item['quantity'] > 1) {
                                    item['quantity'] -= 1;
                                  } else {
                                    wishlistItems.removeAt(index);
                                  }
                                });
                              },
                              onAdd: () {
                                setState(() {
                                  item['quantity'] += 1;
                                });
                              },
                            ),
                          );
                        },
                      ),
              ),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Browse Menu"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Place Order"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
