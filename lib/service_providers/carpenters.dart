
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:servable/theme_provider/themeprovider.dart';
// import 'package:servable/workers_individuals_profile/carpenters_individual.dart';

// class CarpentersProvider with ChangeNotifier {
//   List<Map<String, dynamic>> _carpenters = [];
//   List<Map<String, dynamic>> _filteredCarpenters = [];

//   List<Map<String, dynamic>> get carpenters => _filteredCarpenters;

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   Future<void> fetchcarpenters() async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('Worker')
//           .where('categories', arrayContains: 'Carpenter')
//           .get();

//       _carpenters = snapshot.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         data['uid'] = doc.id;
//         return data;
//       }).toList();

//       _filteredCarpenters = List.from(_carpenters);
//       notifyListeners();
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   void searchworker(String query) {
//     if (query.isEmpty) {
//       _filteredCarpenters = List.from(_carpenters);
//     } else {
//       _filteredCarpenters = _carpenters
//           .where((carpenter) =>
//               carpenter['city'] != null &&
//               carpenter['city'].toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     }
//     notifyListeners();
//   }
// }

// class Carpenters extends StatefulWidget {
//   const Carpenters({super.key});

//   @override
//   State<Carpenters> createState() => _CarpentersState();
// }

// class _CarpentersState extends State<Carpenters> {
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<CarpentersProvider>(context, listen: false).fetchcarpenters();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final carpenterProvider = Provider.of<CarpentersProvider>(context);
//     final themeProvider = Provider.of<Themeprovider>(context);
//     final isDark = themeProvider.themeMode == ThemeMode.dark;

//     const greenColor = Color(0xFF00A86B);
//     final cardColor = isDark ? Colors.grey[850] : const Color(0xFFDFFFE0);
//     final textColor = isDark ? Colors.white : Colors.black87;
//     final subtitleColor = isDark ? Colors.grey[300] : Colors.grey[700];

//     return Scaffold(
//       backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF00A86B), Colors.teal],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Carpenters',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//             fontSize: 22,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: TextField(
//               controller: _searchController,
//               onChanged: (value) {
//                 carpenterProvider.searchworker(value);
//               },
//               decoration: InputDecoration(
//                 hintText: 'Search by City...',
//                 prefixIcon: const Icon(Icons.search),
//                 filled: true,
//                 fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: carpenterProvider.isLoading
//                 ? const Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(greenColor),
//                     ),
//                   )
//                 : carpenterProvider.carpenters.isEmpty
//                     ? const Center(
//                         child: Text(
//                           'No carpenters found',
//                           style: TextStyle(fontSize: 18, color: Colors.grey),
//                         ),
//                       )
//                     : ListView.builder(
//                         physics: const BouncingScrollPhysics(),
//                         padding: const EdgeInsets.all(10),
//                         itemCount: carpenterProvider.carpenters.length,
//                         itemBuilder: (context, index) {
//                           var carpenter = carpenterProvider.carpenters[index];
//                           return AnimatedContainer(
//                             duration: const Duration(milliseconds: 300),
//                             curve: Curves.easeInOut,
//                             child: Card(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               elevation: 4,
//                               margin: const EdgeInsets.symmetric(vertical: 8),
//                               color: cardColor,
//                               child: ListTile(
//                                 contentPadding: const EdgeInsets.all(15),
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           CarpentersIndividual(carpenter: carpenter),
//                                     ),
//                                   );
//                                 },
//                                 leading: CircleAvatar(
//                                   backgroundColor: greenColor.withOpacity(0.8),
//                                   radius: 30,
//                                   child: const Icon(
//                                     Icons.handyman,
//                                     size: 30,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 title: Text(
//                                   carpenter['name']?.toString() ?? 'No Name',
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: textColor,
//                                   ),
//                                 ),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     const SizedBox(height: 6),
//                                     Row(
//                                       children: [
//                                         const Icon(Icons.location_on,
//                                             size: 16, color: Colors.grey),
//                                         const SizedBox(width: 4),
//                                         Text(
//                                           carpenter['city']?.toString() ?? 'No city',
//                                           style: TextStyle(
//                                             color: subtitleColor,
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Row(
//                                       children: [
//                                         const Icon(Icons.star,
//                                             size: 16, color: Colors.orange),
//                                         const SizedBox(width: 4),
//                                         Text(
//                                           "${carpenter['rating'] ?? 0.0} / 5",
//                                           style: TextStyle(
//                                             color: subtitleColor,
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       "Experience: ${carpenter['experience'] ?? 'N/A'} years",
//                                       style: TextStyle(
//                                         color: subtitleColor,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 trailing: const Icon(
//                                   Icons.arrow_forward_ios,
//                                   size: 18,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/theme_provider/themeprovider.dart';
import 'package:servable/workers_individuals_profile/carpenters_individual.dart';

class CarpentersProvider with ChangeNotifier {
  List<Map<String, dynamic>> _carpenters = [];
  List<Map<String, dynamic>> _filteredCarpenters = [];

  List<Map<String, dynamic>> get carpenters => _filteredCarpenters;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchcarpenters() async {
    _isLoading = true;
    notifyListeners();
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Worker')
          .where('categories', arrayContains: 'Carpenter')
          .get();

      _carpenters = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return data;
      }).toList();

      _filteredCarpenters = List.from(_carpenters);
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchworker(String query) {
    if (query.isEmpty) {
      _filteredCarpenters = List.from(_carpenters);
    } else {
      _filteredCarpenters = _carpenters
          .where((carpenter) =>
              carpenter['city'] != null &&
              carpenter['city'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}

class Carpenters extends StatefulWidget {
  const Carpenters({super.key});

  @override
  State<Carpenters> createState() => _CarpentersState();
}

class _CarpentersState extends State<Carpenters> {
  final TextEditingController _searchController = TextEditingController();

  // Embedded translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'appTitle': 'Carpenters',
      'searchHint': 'Search by City...',
      'noCarpentersFound': 'No carpenters found',
      'experienceLabel': 'Experience: {years} years',
    },
    'ur': {
      'appTitle': 'بڑھئی',
      'searchHint': 'شہر کے لحاظ سے تلاش کریں...',
      'noCarpentersFound': 'کوئی بڑھئی نہیں ملا',
      'experienceLabel': 'تجربہ: {years} سال',
    },
  };

  String _translate(String key, String language, {String? placeholder}) {
    String text = _translations[language]?[key] ?? key;
    if (placeholder != null && text.contains('{years}')) {
      text = text.replaceAll('{years}', placeholder);
    }
    return text;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CarpentersProvider>(context, listen: false).fetchcarpenters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final carpenterProvider = Provider.of<CarpentersProvider>(context);
    final themeProvider = Provider.of<Themeprovider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final isUrdu = languageProvider.isUrdu;
    final language = languageProvider.language;

    const greenColor = Color(0xFF00A86B);
    final cardColor = isDark ? Colors.grey[850] : const Color(0xFFDFFFE0);
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[300] : Colors.grey[700];

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _translate('appTitle', language),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
          ),
          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
        ),
        centerTitle: true,
        actions: [
          // Language toggle button (EasyPaisa-styled)
          // GestureDetector(
          //   onTap: () {
          //     languageProvider.toggleLanguage();
          //   },
          //   child: Container(
          //     width: 80,
          //     height: 36,
          //     margin: const EdgeInsets.only(right: 8),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(18),
          //       border: Border.all(color: const Color(0xFF00A86B), width: 2),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.1),
          //           blurRadius: 4,
          //           offset: const Offset(0, 2),
          //         ),
          //       ],
          //     ),
          //     child: Stack(
          //       children: [
          //         AnimatedAlign(
          //           alignment: isUrdu ? Alignment.centerRight : Alignment.centerLeft,
          //           duration: const Duration(milliseconds: 200),
          //           curve: Curves.easeInOut,
          //           child: Container(
          //             width: 40,
          //             height: 36,
          //             decoration: BoxDecoration(
          //               color: const Color(0xFF00A86B),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                carpenterProvider.searchworker(value);
              },
              decoration: InputDecoration(
                hintText: _translate('searchHint', language),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
            ),
          ),
          Expanded(
            child: carpenterProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(greenColor),
                    ),
                  )
                : carpenterProvider.carpenters.isEmpty
                    ? Center(
                        child: Text(
                          _translate('noCarpentersFound', language),
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(10),
                        itemCount: carpenterProvider.carpenters.length,
                        itemBuilder: (context, index) {
                          var carpenter = carpenterProvider.carpenters[index];
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              color: cardColor,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(15),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CarpentersIndividual(carpenter: carpenter),
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundColor: greenColor.withOpacity(0.8),
                                  radius: 30,
                                  child: const Icon(
                                    Icons.handyman,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  carpenter['name']?.toString() ?? 'No Name',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                    fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                  ),
                                  textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: isUrdu
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 6),
                                    Row(
                                      textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                      children: [
                                        const Icon(Icons.location_on,
                                            size: 16, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          carpenter['city']?.toString() ?? 'No city',
                                          style: TextStyle(
                                            color: subtitleColor,
                                            fontSize: 14,
                                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                          ),
                                          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                      children: [
                                        const Icon(Icons.star,
                                            size: 16, color: Colors.orange),
                                        const SizedBox(width: 4),
                                        Text(
                                          "${carpenter['rating'] ?? 0.0} / 5",
                                          style: TextStyle(
                                            color: subtitleColor,
                                            fontSize: 14,
                                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                          ),
                                          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _translate('experienceLabel', language,
                                          placeholder: carpenter['experience']?.toString() ?? 'N/A'),
                                      style: TextStyle(
                                        color: subtitleColor,
                                        fontSize: 14,
                                        fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                      ),
                                      textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                    ),
                                  ],
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}