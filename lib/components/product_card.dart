import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ButtonState { idle, loading, success }

class ProductCard extends StatefulWidget {
  final String name;
  final double price;
  final String imagePath;
  final String category;
  final VoidCallback onAddToWishlist;

  const ProductCard({
    Key? key,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.category,
    required this.onAddToWishlist,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  ButtonState _state = ButtonState.idle;

  void _handleAdd() async {
    if (_state != ButtonState.idle) return;

    setState(() => _state = ButtonState.loading);
    await Future.delayed(const Duration(milliseconds: 800));

    widget.onAddToWishlist();

    setState(() => _state = ButtonState.success);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _state = ButtonState.idle);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image with Category Tag
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      widget.category,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Item Name and Price
          Text(
            widget.name,
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "₹${widget.price.toStringAsFixed(0)}",
            style: GoogleFonts.roboto(color: Colors.green),
          ),

          // Add to Wishlist Button with animation
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: _handleAdd,
              borderRadius: BorderRadius.circular(100),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _state == ButtonState.success
                      ? Colors.green
                      : Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _state == ButtonState.loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          _state == ButtonState.success ? Icons.check : Icons.add,
                          key: ValueKey(_state),
                          color: Colors.white,
                          size: 20,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
