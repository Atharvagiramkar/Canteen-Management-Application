import 'dart:async'; 
import 'package:canteen_management_app/wishlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:canteen_management_app/components/side_nav_door.dart';
import 'package:canteen_management_app/components/product_card.dart';
import 'package:canteen_management_app/components/bottom_nav_bar.dart';
// import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  final List<String> categories = ["All", "Snacks", "Meals", "Drinks", "Dessert"];
  int selectedCategoryIndex = 0;
  final int totalSlides = 5;
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;
  
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Veg Sandwich',
      'price': 49.0,
      'image': 'assets/images/apple.png',
      'category': 'Snacks',
    },
    {
      'name': 'Cold Coffee',
      'price': 35.0,
      'image': 'assets/images/sample_food.png',
      'category': 'Drinks',
    },
    {
      'name': 'Cold Coffee with Crush',
      'price': 40.0,
      'image': 'assets/images/sample_food.png',
      'category': 'Dessert',
    },
    {
      'name': 'Aloo Paratha',
      'price': 40.0,
      'image': 'assets/images/sample_food.png',
      'category': 'Meals',
    },
    {
      'name': 'Gulab Jamun',
      'price': 25.0,
      'image': 'assets/images/sample_food.png',
      'category': 'Dessert',
    },
  ];

  
  List<Map<String, dynamic>> wishlist = [];


  @override 
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 4) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
  
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideNavDrawer(username: user?.email ?? "Guest"),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: Text("Canteen Management App"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search food, drinks...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Popular Options Carousel
              Text("Popular Options", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              SizedBox(
                height: 180,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: totalSlides,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.orange.shade100,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/sample_food.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(totalSlides, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 12 : 8,
                    height: _currentPage == index ? 12 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index ? Colors.green : Colors.grey[400],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              Text("Categories", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ChoiceChip(
                      label: Text(categories[index]),
                      selected: selectedCategoryIndex == index,
                      onSelected: (val) => setState(() {
                        selectedCategoryIndex = index;
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Product Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    name: product['name'],
                    price: product['price'],
                    imagePath: product['image'],
                    category: product['category'],
                    onAddToWishlist: () {
                      setState(() {
                        final existingIndex = wishlist.indexWhere((item) => item['name'] == product['name']);
                        if (existingIndex != -1) {
                          wishlist[existingIndex]['quantity'] += 1;
                        } else {
                          wishlist.add({
                            ...product,
                            'imagePath': product['image'], // make sure the key matches WishlistCard
                            'quantity': 1
                          });
                        }
                      });
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.green,
      //   child: const Icon(Icons.favorite, color: Colors.white),
      //   onPressed: () {
      //     // Navigator.push(
      //     //   context,
      //     //   MaterialPageRoute(
      //     //     builder: (context) => WishlistPage(wishlist: wishlist),
      //     //   ),
      //     // );
      //   },
      // ),

      // Bottom Nav
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0, // Set current index dynamically for other pages
        onTap: (index) {
          // Navigation logic
          switch (index) {
            case 0:
              Navigator.push(context, MaterialPageRoute(builder: (context) => Homepage()));
              break;
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (context) => WishlistPage(wishlist: wishlist)));
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/orders');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}

