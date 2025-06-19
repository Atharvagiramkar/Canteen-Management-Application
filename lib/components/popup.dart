import 'package:flutter/material.dart';

void showCustomPopup({
  required BuildContext context,
  required IconData icon,
  required String title,
  required String message,
  String? primaryBtnText,
  VoidCallback? onPrimaryPressed,
  String? secondaryBtnText,
  VoidCallback? onSecondaryPressed,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 60, color: Colors.green),
          const SizedBox(height: 15),
          Text(title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.green
              )),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (secondaryBtnText != null)
                ElevatedButton(
                  onPressed: onSecondaryPressed ?? () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    secondaryBtnText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    )),
                ),
              if (primaryBtnText != null)
                ElevatedButton(
                  onPressed: onPrimaryPressed ?? () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                  child: Text(
                    primaryBtnText,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}
