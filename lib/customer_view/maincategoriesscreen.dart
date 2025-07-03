// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:servable/Screens/category_selection.dart';
// import 'package:servable/Screens/constructions_services.dart';
// import 'package:servable/customer_view/construction_services.dart';
// import 'package:servable/customer_view/customer_profilescreen.dart';
// import 'package:servable/customer_view/services.dart';
// import 'package:servable/customer_view/settings.dart';
// import 'package:servable/customer_view/vehicalservices.dart';
// import 'package:servable/theme_provider/themeprovider.dart';



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
// class Maincategoriesscreen extends StatelessWidget {
//   const Maincategoriesscreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final themeProvider = Provider.of<Themeprovider>(context);
//     final customerProvider = Provider.of<CustomerProvider>(context);

//     final bgColor = isDark ? Colors.black : const Color(0xFFF1FCF7);
//     final textColor = isDark ? Colors.white : Colors.black87;
//     return Scaffold(
//       backgroundColor: bgColor,
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
//      drawer: Drawer(
//         child: Container(
//           color: bgColor,
//           child: ListView(
//             padding: EdgeInsets.zero,
//             children: [
//               DrawerHeader(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [const Color(0xFF00A86B), Colors.teal],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircleAvatar(
//                         radius: 35,
//                         backgroundColor: Colors.white,
//                         child: customerProvider.image != null
//                             ? ClipOval(
//                                 child: Image.file(
//                                   customerProvider.image!,
//                                   fit: BoxFit.cover,
//                                   width: 70,
//                                   height: 70,
//                                 ),
//                               )
//                             : Icon(
//                                 Icons.person,
//                                 size: 40,
//                                 color: const Color(0xFF00A86B),
//                               ),
//                       ),
//                       SizedBox(height: 12),
//                       Text(
//                         customerProvider.userData?['name'] ?? 'Profile Name',
//                         style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       Text(
//                         customerProvider.userData?['email'] ?? '',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.white70,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               _buildDrawerItem(
//                 context: context,
//                 title: themeProvider.themeMode==ThemeMode.dark?'L I G H T T H E M E':'D A R K T H E M E',
//                 icon: isDark ? Icons.light_mode : Icons.dark_mode,
//                 textColor: textColor,
//                 onTap: () => themeProvider.toggle_theme(),
//               ),
//               Divider(color: isDark ? Colors.grey[700] : Colors.grey[400]),
//               _buildDrawerItem(
//                 context: context,
//                 title: 'S E T T I N G S',
//                 icon: Icons.settings_sharp,
//                 textColor: textColor,
//                 onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => setting())),
//               ),
//               Divider(color: isDark ? Colors.grey[700] : Colors.grey[400]),
//               _buildDrawerItem(
//                 context: context,
//                 title: 'P R O F I L E',
//                 icon: Icons.account_circle,
//                 textColor: textColor,
//                 onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerProfileScreen())),
//               ),
//             ],
//           ),
//         ),
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
//                     builder: (context) => Services(),
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
//                     builder: (context) => Vehicalservices(),
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
//                     builder: (context) => ConstructionProviders()
//                   ),
//                 );
//               },
//             ),
//             // _buildCategoryCard(
//             //   context: context,
//             //   title: 'Fashion Services',
//             //   icon: Icons.style,
//             //   isDark: isDark,
//             //   onTap: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(
//             //         builder: (context) =>
//             //       ),
//             //     );
//             //   },
//             // ),
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

//  Widget _buildDrawerItem({
//     required BuildContext context,
//     required String title,
//     required IconData icon,
//     required Color textColor,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         child: Row(
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 color: textColor,
//                 letterSpacing: 1.5,
//               ),
//             ),
//             Spacer(),
//             Icon(
//               icon,
//               color: textColor,
//               size: 28,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/category_selection.dart';
import 'package:servable/Screens/constructions_services.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/customer_view/construction_services.dart';
import 'package:servable/customer_view/customer_profilescreen.dart';
import 'package:servable/customer_view/services.dart';
import 'package:servable/customer_view/settings.dart';
import 'package:servable/customer_view/vehicalservices.dart';
import 'package:servable/theme_provider/themeprovider.dart';



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

class Maincategoriesscreen extends StatelessWidget {
  const Maincategoriesscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final customerProvider = Provider.of<CustomerProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final isUrdu = languageProvider.isUrdu;
    final language = languageProvider.language;
    final bgColor = isDark ? Colors.black : const Color(0xFFF1FCF7);
    final textColor = isDark ? Colors.white : Colors.black87;

    // Embedded translations
    final Map<String, Map<String, String>> translations = {
      'en': {
        'chooseCategory': 'Choose a Category',
        'homeServices': 'Home Services',
        'vehicleServices': 'Vehicle Services',
        'healthServices': 'Health Services',
        'educationServices': 'Education Services',
        'constructionServices': 'Construction Services',
        'fashionServices': 'Fashion Services',
        'profileName': 'Profile Name',
        'lightTheme': 'Light Theme',
        'darkTheme': 'Dark Theme',
        'settings': 'Settings',
        'profile': 'Profile',
        'language': 'Language',
      },
      'ur': {
        'chooseCategory': 'ایک زمرہ منتخب کریں',
        'homeServices': 'گھریلو خدمات',
        'vehicleServices': 'گاڑیوں کی خدمات',
        'healthServices': 'صحت کی خدمات',
        'educationServices': 'تعلیمی خدمات',
        'constructionServices': 'تعمیراتی خدمات',
        'fashionServices': 'فیشن خدمات',
        'profileName': 'پروفائل کا نام',
        'lightTheme': 'ہلکی تھیم',
        'darkTheme': 'گہری تھیم',
        'settings': 'ترتیبات',
        'profile': 'پروفائل',
        'language': 'زبان',
      },
    };

    String translate(String key) {
      return translations[language]?[key] ?? key;
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          translate('chooseCategory'),
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
      drawer: Drawer(
        child: Container(
          color: bgColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF00A86B), Colors.teal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: isUrdu ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: customerProvider.image != null
                            ? ClipOval(
                                child: Image.file(
                                  customerProvider.image!,
                                  fit: BoxFit.cover,
                                  width: 70,
                                  height: 70,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 40,
                                color: const Color(0xFF00A86B),
                              ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        customerProvider.userData?['name'] ?? translate('profileName'),
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                        textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                      ),
                      Text(
                        customerProvider.userData?['email'] ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                        textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
              ),
              _buildDrawerItem(
                context: context,
                title: isDark ? translate('lightTheme') : translate('darkTheme'),
                icon: isDark ? Icons.light_mode : Icons.dark_mode,
                textColor: textColor,
                onTap: () => themeProvider.toggle_theme(),
              ),
              Divider(color: isDark ? Colors.grey[700] : Colors.grey[400]),
              _buildDrawerItem(
                context: context,
                title: translate('settings'),
                icon: Icons.settings_sharp,
                textColor: textColor,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => setting())),
              ),
              Divider(color: isDark ? Colors.grey[700] : Colors.grey[400]),
              _buildDrawerItem(
                context: context,
                title: translate('profile'),
                icon: Icons.account_circle,
                textColor: textColor,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerProfileScreen())),
              ),
              Divider(color: isDark ? Colors.grey[700] : Colors.grey[400]),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    Text(
                      translate('language'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        letterSpacing: 1.5,
                        fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                      ),
                      textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                    ),
                    // EasyPaisa-styled toggle button
                    GestureDetector(
                      onTap: () {
                        languageProvider.toggleLanguage();
                      },
                      child: Container(
                        width: 80,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Color(0xFF00A86B), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            AnimatedAlign(
                              alignment: isUrdu ? Alignment.centerRight : Alignment.centerLeft,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              child: Container(
                                width: 40,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Color(0xFF00A86B),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      'EN',
                                      style: TextStyle(
                                        color: isUrdu ? Colors.grey : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      'UR',
                                      style: TextStyle(
                                        color: isUrdu ? Colors.white : Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
              title: translate('homeServices'),
              icon: Icons.home_repair_service,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Services(),
                  ),
                );
              },
            ),
            _buildCategoryCard(
              context: context,
              title: translate('vehicleServices'),
              icon: Icons.directions_car,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Vehicalservices(),
                  ),
                );
              },
            ),
            _buildCategoryCard(
              context: context,
              title: translate('constructionServices'),
              icon: Icons.construction,
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConstructionProviders(),
                  ),
                );
              },
            ),
            // _buildCategoryCard(
            //   context: context,
            //   title: _translate('fashionServices'),
            //   icon: Icons.style,
            //   isDark: isDark,
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => PlaceholderScreen(category: _translate('fashionServices')),
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final isUrdu = Provider.of<LanguageProvider>(context).isUrdu;
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
              title,
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

  Widget _buildDrawerItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    final isUrdu = Provider.of<LanguageProvider>(context).isUrdu;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
                letterSpacing: 1.5,
                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
              ),
              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
            ),
            Spacer(),
            Icon(
              icon,
              color: textColor,
              size: 28,
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
    final isUrdu = Provider.of<LanguageProvider>(context).isUrdu;
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
          isUrdu ? 'اس زمرے کے لیے ذیلی زمرہ جات یہاں ہوں گے' : 'Subcategories for $category will be here',
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