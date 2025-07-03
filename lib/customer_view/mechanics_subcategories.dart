
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/customer_view/vechical_subcat_setect.dart';
import 'package:servable/service_providers/bikerepair.dart';
import 'package:servable/service_providers/carpenters.dart';
import 'package:servable/service_providers/cartowing.dart';
import 'package:servable/service_providers/carwash.dart';
import 'package:servable/service_providers/chefs.dart';
import 'package:servable/service_providers/electrician_profile.dart';
import 'package:servable/service_providers/gerdeners.dart';
import 'package:servable/service_providers/mechanic.dart';
import 'package:servable/theme_provider/themeprovider.dart';




class MechanicsSubcategories extends StatefulWidget {
  const MechanicsSubcategories({super.key});

  @override
  State<MechanicsSubcategories> createState() => _MechanicsSubcategoriesState();
}

class _MechanicsSubcategoriesState extends State<MechanicsSubcategories> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
      
    // Listen to search input changes
    _searchController.addListener(() {
      setState(() {}); // Trigger rebuild on search input change
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final bgColor = isDark ? Colors.black : const Color(0xFFF1FCF7);
    final textColor = isDark ? Colors.white : Colors.black87;
    final query = _searchController.text.toLowerCase();

    // List of MechanicsSubcategories
    final MechanicsSubcategories = [
      serviceTile(context, "Mechanic", "assets/mechanic.jpeg", const Mechanics()),
      serviceTile(context, "Car Electrician", "assets/carelectrician.png", const Electricians()),
      
      
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF00A86B), Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "MechanicsSubcategories",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search ....',
                    hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                    prefixIcon: Icon(Icons.search, color: textColor),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: textColor),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Color(0xFF00A86B)),
                    ),
                  ),
                  style: TextStyle(color: textColor),
                ),
              ),
              const SizedBox(height: 20),
              // GridView for MechanicsSubcategories
              Expanded(
                child: MechanicsSubcategories.isEmpty
                    ? Center(
                        child: Text(
                          "No MechanicsSubcategories found",
                          style: TextStyle(color: textColor, fontSize: 16),
                        ),
                      )
                    : GridView.count(
                        crossAxisCount: 2, // 3 columns for smaller tiles
                        mainAxisSpacing: 20, // Reduced spacing
                        crossAxisSpacing: 20, // Reduced spacing
                        childAspectRatio: 0.75, // Adjusted for dynamic text height
                        children: MechanicsSubcategories,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget serviceTile(BuildContext context, String label, String imgPath, Widget page) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.grey[900]!, Colors.grey[850]!]
                : [Colors.white, Colors.grey[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Image
                  Expanded(
                    flex: 6,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.asset(
                        imgPath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.15), // Subtle darkening
                        colorBlendMode: BlendMode.darken,
                        errorBuilder: (context, error, stackTrace) {
                          print('Failed to load image: $imgPath'); // Debug log
                          return Container(
                            color: const Color.fromARGB(255, 151, 151, 151),
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 50, color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Text label below image
                  Container(
                    width: double.infinity,
                    color: isDark ? Colors.grey[800] : Colors.grey[200],
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4), // Reduced padding
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: null, // Unlimited lines for long names
                      softWrap: true,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 15, // Smaller font for long names
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}