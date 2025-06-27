import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WishlistProductCard extends StatelessWidget {
  final String name;
  final double price;
  final String imagePath;
  final String category;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const WishlistProductCard({
    Key? key,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.category,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
      child: Row(
        children: [
          // Image Box
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(category),
                Text("₹${(price * quantity).toStringAsFixed(0)}"),
              ],
            ),
          ),
           Row(
            children: [
              FloatingActionButton.small(
                heroTag: 'removeWishlistItem-$name',
                backgroundColor: Colors.red,
                onPressed: onRemove,
                child: const Icon(Icons.remove),
              ),
              const SizedBox(width: 6),
              Text(
                quantity.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              FloatingActionButton.small(
                heroTag: 'addWishlistItem-$name',
                backgroundColor: Colors.green,
                onPressed: onAdd,
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }
}