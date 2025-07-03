
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:servable/customer_view/mechanics_subcategories.dart';
// import 'package:servable/customer_view/vechical_subcat_setect.dart';
// import 'package:servable/service_providers/bikerepair.dart';
// import 'package:servable/service_providers/carpenters.dart';
// import 'package:servable/service_providers/cartowing.dart';
// import 'package:servable/service_providers/carwash.dart';
// import 'package:servable/service_providers/chefs.dart';
// import 'package:servable/service_providers/electrician_profile.dart';
// import 'package:servable/service_providers/gerdeners.dart';
// import 'package:servable/service_providers/mechanic.dart';
// import 'package:servable/theme_provider/themeprovider.dart';

// // Data model for service providers
// class ServiceProvider {
//   final String label;
//   final String imgPath;
//   final Widget page;

//   ServiceProvider(this.label, this.imgPath, this.page);
// }

// class TabBarProvider with ChangeNotifier {
//   int _selectedIndex = 0;

//   int get selectedIndex => _selectedIndex;

//   void changeIndex(int index) {
//     _selectedIndex = index;
//     notifyListeners();
//   }
// }

// class Vehicalservices extends StatefulWidget {
//   const Vehicalservices({super.key});

//   @override
//   State<Vehicalservices> createState() => _VehicalservicesState();
// }

// class _VehicalservicesState extends State<Vehicalservices> with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
//     _animationController.forward();

//     // Listen to search input changes
//     _searchController.addListener(() {
//       setState(() {}); // Trigger rebuild on search input change
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<Themeprovider>(context);
//     final isDark = themeProvider.themeMode == ThemeMode.dark;
//     final bgColor = isDark ? Colors.black : const Color(0xFFF1FCF7);
//     final textColor = isDark ? Colors.white : Colors.black87;
//     final query = _searchController.text.toLowerCase();

//     // List of all vehicle services
//     final allVehicalservices = [
//       ServiceProvider("Car Repair", "assets/auto_mechanic.png", const MechanicsSubcategories()),
//       ServiceProvider("Car Wash", "assets/carwash.jpg", const CarWashProviders()),
//       ServiceProvider("Car Towing", "assets/towing.jpeg", Cartowing()),
//       ServiceProvider("Bike Repair", "assets/motorcycle_repair.jpg", const Bikerepair()),
//     ];

//     // Filter services based on search query
//     final filteredVehicalservices = query.isEmpty
//         ? allVehicalservices
//         : allVehicalservices
//             .where((provider) => provider.label.toLowerCase().contains(query))
//             .toList();

//     // Map filtered providers to serviceTile widgets
//     final serviceWidgets = filteredVehicalservices
//         .map((provider) => serviceTile(context, provider.label, provider.imgPath, provider.page))
//         .toList();

//     return Scaffold(
//       backgroundColor: bgColor,
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [const Color(0xFF00A86B), Colors.teal],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.white),
//         centerTitle: true,
//         title: const Text(
//           "Vehical Services",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 24,
//             color: Colors.white,
//             letterSpacing: 1.2,
//           ),
//         ),
//       ),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               // Search bar
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: TextField(
//                   controller: _searchController,
//                   decoration: InputDecoration(
//                     hintText: 'Search Vehical Services',
//                     hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
//                     prefixIcon: Icon(Icons.search, color: textColor),
//                     suffixIcon: _searchController.text.isNotEmpty
//                         ? IconButton(
//                             icon: Icon(Icons.clear, color: textColor),
//                             onPressed: () {
//                               _searchController.clear();
//                             },
//                           )
//                         : null,
//                     filled: true,
//                     fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15),
//                       borderSide: BorderSide.none,
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15),
//                       borderSide: BorderSide(color: Colors.grey[300]!),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(15),
//                       borderSide: const BorderSide(color: Color(0xFF00A86B)),
//                     ),
//                   ),
//                   style: TextStyle(color: textColor),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // GridView for vehicle services
//               Expanded(
//                 child: serviceWidgets.isEmpty
//                     ? Center(
//                         child: Text(
//                           "No vehicle services found",
//                           style: TextStyle(color: textColor, fontSize: 16),
//                         ),
//                       )
//                     : GridView.count(
//                         crossAxisCount: 2,
//                         mainAxisSpacing: 20,
//                         crossAxisSpacing: 20,
//                         childAspectRatio: 0.75,
//                         children: serviceWidgets,
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget serviceTile(BuildContext context, String label, String imgPath, Widget page) {
//     final themeProvider = Provider.of<Themeprovider>(context);
//     final isDark = themeProvider.themeMode == ThemeMode.dark;

//     return GestureDetector(
//       onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//           gradient: LinearGradient(
//             colors: isDark
//                 ? [Colors.grey[900]!, Colors.grey[850]!]
//                 : [Colors.white, Colors.grey[200]!],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(16),
//             onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
//             child: IntrinsicHeight(
//               child: Column(
//                 children: [
//                   // Image
//                   Expanded(
//                     flex: 6,
//                     child: ClipRRect(
//                       borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//                       child: Image.asset(
//                         imgPath,
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                         color: Colors.black.withOpacity(0.15),
//                         colorBlendMode: BlendMode.darken,
//                         errorBuilder: (context, error, stackTrace) {
//                           print('Failed to load image: $imgPath');
//                           return Container(
//                             color: const Color.fromARGB(255, 151, 151, 151),
//                             child: const Center(
//                               child: Icon(Icons.broken_image, size: 50, color: Colors.white),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                   // Text label below image
//                   Container(
//                     width: double.infinity,
//                     color: isDark ? Colors.grey[800] : Colors.grey[200],
//                     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
//                     child: Text(
//                       label,
//                       textAlign: TextAlign.center,
//                       maxLines: null,
//                       softWrap: true,
//                       style: TextStyle(
//                         color: isDark ? Colors.white : Colors.black87,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                         letterSpacing: 0.8,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/customer_view/mechanics_subcategories.dart';
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

// Data model for service providers with localized labels
class ServiceProvider {
  final Map<String, String> labels; // Map for English and Urdu labels
  final String imgPath;
  final Widget page;

  ServiceProvider(this.labels, this.imgPath, this.page);

  String getLabel(String language) {
    return labels[language] ?? labels['en']!; // Default to English if translation missing
  }
}

class TabBarProvider with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void changeIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

class Vehicalservices extends StatefulWidget {
  const Vehicalservices({super.key});

  @override
  State<Vehicalservices> createState() => _VehicalservicesState();
}

class _VehicalservicesState extends State<Vehicalservices> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();

  // Embedded translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'appTitle': 'Vehical Services',
      'searchHint': 'Search Vehical Services',
      'noServicesFound': 'No vehicle services found',
    },
    'ur': {
      'appTitle': 'وہیکل خدمات',
      'searchHint': 'وہیکل خدمات تلاش کریں',
      'noServicesFound': 'کوئی وہیکل خدمات نہیں ملیں',
    },
  };

  String _translate(String key, String language) {
    return _translations[language]?[key] ?? key;
  }

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
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final isUrdu = languageProvider.isUrdu;
    final language = languageProvider.language;
    final bgColor = isDark ? Colors.black : const Color(0xFFF1FCF7);
    final textColor = isDark ? Colors.white : Colors.black87;
    final query = _searchController.text.toLowerCase();

    // List of all vehicle services with localized labels
    final allVehicalservices = [
      ServiceProvider(
        {'en': 'Car Repair', 'ur': 'کار مرمت'},
        "assets/auto_mechanic.png",
        const MechanicsSubcategories(),
      ),
      ServiceProvider(
        {'en': 'Car Wash', 'ur': 'کار واٹر'},
        "assets/carwash.jpg",
        const CarWashProviders(),
      ),
      ServiceProvider(
        {'en': 'Car Towing', 'ur': 'کار ٹوئنگ'},
        "assets/towing.jpeg",
        Cartowing(),
      ),
      ServiceProvider(
        {'en': 'Bike Repair', 'ur': 'بائیک مرمت'},
        "assets/motorcycle_repair.jpg",
        const Bikerepair(),
      ),
    ];

    // Filter services based on search query
    final filteredVehicalservices = query.isEmpty
        ? allVehicalservices
        : allVehicalservices
            .where((provider) => provider.getLabel(language).toLowerCase().contains(query))
            .toList();

    // Map filtered providers to serviceTile widgets
    final serviceWidgets = filteredVehicalservices
        .map((provider) => serviceTile(context, provider.getLabel(language), provider.imgPath, provider.page))
        .toList();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00A86B), Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          _translate('appTitle', language),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 1.2,
            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
          ),
          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.language, color: Colors.white),
          //   onPressed: () {
          //     languageProvider.toggleLanguage();
          //   },
          // ),
        ],
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
                    hintText: _translate('searchHint', language),
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
                  textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                ),
              ),
              const SizedBox(height: 20),
              // GridView for vehicle services
              Expanded(
                child: serviceWidgets.isEmpty
                    ? Center(
                        child: Text(
                          _translate('noServicesFound', language),
                          style: TextStyle(color: textColor, fontSize: 16),
                          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      )
                    : GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 0.75,
                        children: serviceWidgets,
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
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final isUrdu = languageProvider.isUrdu;

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
                        color: Colors.black.withOpacity(0.15),
                        colorBlendMode: BlendMode.darken,
                        errorBuilder: (context, error, stackTrace) {
                          print('Failed to load image: $imgPath');
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
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: null,
                      softWrap: true,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 0.8,
                        fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                      ),
                      textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
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