// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:servable/Screens/category_selection.dart' ;
// import 'package:servable/Screens/constructions_services.dart';
// import 'package:servable/Screens/fashion_category_service.dart';
// import 'package:servable/Screens/vehical_service_category.dart';
// import 'package:servable/customer_view/maincategoriesscreen.dart';



// final List<String> _categoryNames = [
//   'Home Services',
//   'Vehicle Services',
//   'Health Services',
//   'Education Services',
//   'Construction Services',
//   'Fashion Services',
// ];

// final List<IconData> _categoryIcons = [
//   Icons.home_repair_service,
//   Icons.directions_car,
//   Icons.local_hospital,
//   Icons.school,
//   Icons.construction,
//   Icons.style,
// ];
// class CategoryChoiceScreen extends StatelessWidget {
//   const CategoryChoiceScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     // final checkboxchild = Provider.of<CheckboxProvider>(context);
//     return Scaffold(
//       backgroundColor: Color(0xFFF1FCF7),
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           'Choose a Category',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF00A86B), Colors.teal],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
      
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: GridView.count(
//           crossAxisCount: 2,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//           children: [
//             _buildCategoryCard(
//               context: context,
//               title: 'Home Services',
//               icon: Icons.home_repair_service,
//               isDark: isDark,
//               onTap: () {
//                 // Navigate to subcategory screen or other action
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CategorySelectionScreen(),
//                   ),
//                 );
//               },
//             ),
//             _buildCategoryCard(
//               context: context,
//               title: 'Vehicle Services',
//               icon: Icons.directions_car,
//               isDark: isDark,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => VehicalServiceCategory()
//                   ),
//                 );
//               },
//             ),
           
//             _buildCategoryCard(
//               context: context,
//               title: 'Construction Services',
//               icon: Icons.construction,
//               isDark: isDark,
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => construction()
//                   ),
//                 );
//               },
//             ),
            
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryCard({
//     required BuildContext context,
//     required String title,
//     required IconData icon,
//     required bool isDark,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 4,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         color: isDark ? Colors.grey[800] : Colors.white,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               size: 50,
//               color: const Color(0xFF00A86B),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: isDark ? Colors.white : Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Placeholder screen for navigation
// class PlaceholderScreen extends StatelessWidget {
//   final String category;

//   const PlaceholderScreen({super.key, required this.category});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           category,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF00A86B), Colors.teal],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Center(
//         child: Text(
//           'Subcategories for $category will be here',
//           style: const TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/category_selection.dart';
import 'package:servable/Screens/constructions_services.dart';
import 'package:servable/Screens/fashion_category_service.dart';
import 'package:servable/Screens/vehical_service_category.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/customer_view/maincategoriesscreen.dart';

// class LanguageProvider with ChangeNotifier {
//   String _language = 'en';

//   String get language => _language;
//   bool get isUrdu => _language == 'ur';

//   void toggleLanguage() {
//     _language = _language == 'en' ? 'ur' : 'en';
//     notifyListeners();
//   }
// }

class CategoryChoiceScreen extends StatelessWidget {
   CategoryChoiceScreen({super.key});

  // Embedded translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'chooseCategory': 'Choose a Category',
      'homeServices': 'Home Services',
      'vehicleServices': 'Vehicle Services',
      'healthServices': 'Health Services',
      'educationServices': 'Education Services',
      'constructionServices': 'Construction Services',
      'fashionServices': 'Fashion Services',
    },
    'ur': {
      'chooseCategory': 'ایک زمرہ منتخب کریں',
      'homeServices': 'گھریلو خدمات',
      'vehicleServices': 'گاڑیوں کی خدمات',
      'healthServices': 'صحت کی خدمات',
      'educationServices': 'تعلیمی خدمات',
      'constructionServices': 'تعمیراتی خدمات',
      'fashionServices': 'فیشن خدمات',
    },
  };

  String _translate(String key, String language) {
    return _translations[language]?[key] ?? key;
  }

  // Category keys for translation
  final List<String> _categoryKeys = [
    'homeServices',
    'vehicleServices',
    'healthServices',
    'educationServices',
    'constructionServices',
    'fashionServices',
  ];

  final List<IconData> _categoryIcons = [
    Icons.home_repair_service,
    Icons.directions_car,
    Icons.local_hospital,
    Icons.school,
    Icons.construction,
    Icons.style,
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isUrdu = languageProvider.isUrdu;
    final language = languageProvider.language;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF1FCF7),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _translate('chooseCategory', language),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
          ),
          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00A86B), Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // EasyPaisa-styled toggle button
          // GestureDetector(
          //   onTap: () {
          //     languageProvider.toggleLanguage();
          //   },
          //   child: Container(
          //     width: 80,
          //     height: 36,
          //     margin: EdgeInsets.only(right: 8),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(18),
          //       border: Border.all(color: Color(0xFF00A86B), width: 2),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.1),
          //           blurRadius: 4,
          //           offset: Offset(0, 2),
          //         ),
          //       ],
          //     ),
          //     child: Stack(
          //       children: [
          //         AnimatedAlign(
          //           alignment: isUrdu ? Alignment.centerRight : Alignment.centerLeft,
          //           duration: Duration(milliseconds: 200),
          //           curve: Curves.easeInOut,
          //           child: Container(
          //             width: 40,
          //             height: 36,
          //             decoration: BoxDecoration(
          //               color: Color(0xFF00A86B),
          //               borderRadius: BorderRadius.circular(18),
          //             ),
          //           ),
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Expanded(
          //               child: Center(
          //                 child: Text(
          //                   'EN',
          //                   style: TextStyle(
          //                     color: isUrdu ? Colors.grey : Colors.white,
          //                     fontWeight: FontWeight.bold,
          //                     fontSize: 14,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             Expanded(
          //               child: Center(
          //                 child: Text(
          //                   'UR',
          //                   style: TextStyle(
          //                     color: isUrdu ? Colors.white : Colors.grey,
          //                     fontWeight: FontWeight.bold,
          //                     fontSize: 14,
          //                     fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCategoryCard(
              context: context,
              titleKey: 'homeServices',
              icon: Icons.home_repair_service,
              isDark: isDark,
              isUrdu: isUrdu,
              language: language,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategorySelectionScreen(),
                  ),
                );
              },
            ),
            _buildCategoryCard(
              context: context,
              titleKey: 'vehicleServices',
              icon: Icons.directions_car,
              isDark: isDark,
              isUrdu: isUrdu,
              language: language,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VehicalServiceCategory(),
                  ),
                );
              },
            ),
            _buildCategoryCard(
              context: context,
              titleKey: 'constructionServices',
              icon: Icons.construction,
              isDark: isDark,
              isUrdu: isUrdu,
              language: language,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConstructionServicesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String titleKey,
    required IconData icon,
    required bool isDark,
    required bool isUrdu,
    required String language,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: isDark ? Colors.grey[800] : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: const Color(0xFF00A86B),
            ),
            const SizedBox(height: 10),
            Text(
              _translate(titleKey, language),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
              ),
              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder screen for navigation
class PlaceholderScreen extends StatelessWidget {
  final String category;

  const PlaceholderScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isUrdu = languageProvider.isUrdu;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          category,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
          ),
          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00A86B), Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Text(
          isUrdu ? 'اس زمرے کے ذیلی زمرے یہاں ہوں گے' : 'Subcategories for $category will be here',
          style: TextStyle(
            fontSize: 18,
            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
          ),
          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
        ),
      ),
    );
  }
}