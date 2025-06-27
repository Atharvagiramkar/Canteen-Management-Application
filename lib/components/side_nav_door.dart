import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:canteen_management_app/login.dart';

class SideNavDrawer extends StatelessWidget {
  final String username;
  const SideNavDrawer({Key? key, required this.username}) : super(key: key);

  void signout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyLogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final topHeight = height * 0.30;

    return Drawer(
      child: Column(
        children: [
          // Top section (white background)
          Container(
            height: topHeight,
            width: double.infinity,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, size: 40, color: Colors.black),
                ),
                const SizedBox(height: 40),
                Text(
                  username,
                  style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Bottom section (green background)
          Expanded(
            child: Container(
              color: Colors.green,
              child: Column(
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.dashboard_customize_rounded,
                    title: "Dashboard",
                    onTap: () => Navigator.pushNamed(context, '/overview'),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.restaurant_menu_rounded,
                    title: "Menu",
                    onTap: () => Navigator.pushNamed(context, '/menu'),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.reviews_rounded,
                    title: "Reviews",
                    onTap: () => Navigator.pushNamed(context, '/reviews'),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.local_offer_rounded,
                    title: "Special Offers",
                    onTap: () => Navigator.pushNamed(context, '/offers'),
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.history_edu_rounded,
                    title: "Order History",
                    onTap: () => Navigator.pushNamed(context, '/orderHistory'),
                  ),
                  
                  const SizedBox(height: 20),
                  // Logout Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ElevatedButton.icon(
                      onPressed: () => signout(context),
                      icon: const Icon(Icons.logout_rounded, color: Colors.white),
                      label: const Text("Logout", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 6,
                      ),
                    ),
                  ),
                  

                  const Spacer(),


                  // Back Floating Button
                  FloatingActionButton.small(
                    backgroundColor: Colors.white,
                    elevation: 3,
                    onPressed: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onTap: onTap,
        ),
        const Divider(color: Colors.white70, thickness: 0.4),
      ],
    );
  }
}
