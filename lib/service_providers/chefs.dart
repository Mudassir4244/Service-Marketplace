
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:servable/theme_provider/themeprovider.dart';
// import 'package:servable/workers_individuals_profile/chef_individuals.dart';

// class ChefProvider with ChangeNotifier {
//   List<Map<String, dynamic>> _chefs = [];
//   List<Map<String, dynamic>> _filteredChefs = [];

//   List<Map<String, dynamic>> get chefs => _filteredChefs;

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   Future<void> fetchChefs() async {
//     _isLoading = true;
//     notifyListeners();
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('Worker')
//           .where('categories', arrayContains: 'Chef')
//           .get();

//       _chefs = snapshot.docs.map((doc) {
//         var data = doc.data() as Map<String, dynamic>;
//         data['uid'] = doc.id;
//         return data;
//       }).toList();

//       _filteredChefs = List.from(_chefs);
//       notifyListeners();
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   void searchChefs(String query) {
//     if (query.isEmpty) {
//       _filteredChefs = List.from(_chefs);
//     } else {
//       _filteredChefs = _chefs
//           .where((chef) =>
//               chef['city'] != null &&
//               chef['city'].toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     }
//     notifyListeners();
//   }
// }

// class Chefs extends StatefulWidget {
//   const Chefs({super.key});

//   @override
//   State<Chefs> createState() => _ChefsState();
// }

// class _ChefsState extends State<Chefs> {
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ChefProvider>(context, listen: false).fetchChefs();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final chefProvider = Provider.of<ChefProvider>(context);
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
//           'Chefs',
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
//                 chefProvider.searchChefs(value);
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
//             child: chefProvider.isLoading
//                 ? const Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(greenColor),
//                     ),
//                   )
//                 : chefProvider.chefs.isEmpty
//                     ? const Center(
//                         child: Text(
//                           'No chefs found',
//                           style: TextStyle(fontSize: 18, color: Colors.grey),
//                         ),
//                       )
//                     : ListView.builder(
//                         physics: const BouncingScrollPhysics(),
//                         padding: const EdgeInsets.all(10),
//                         itemCount: chefProvider.chefs.length,
//                         itemBuilder: (context, index) {
//                           var chef = chefProvider.chefs[index];
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
//                                           ChefIndividuals(chef: chef),
//                                     ),
//                                   );
//                                 },
//                                 leading: Container(
//                                   decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     gradient: LinearGradient(
//                                       colors: [Color(0xFF00A86B), Colors.teal],
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomRight,
//                                     ),
//                                   ),
//                                   child: CircleAvatar(
//                                     backgroundColor: Colors.transparent,
//                                     radius: 30,
//                                     child: const Icon(
//                                       Icons.restaurant,
//                                       size: 30,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                                 title: Text(
//                                   chef['name']?.toString() ?? 'No Name',
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
//                                           chef['city']?.toString() ?? 'No city',
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
//                                           "${chef['rating'] ?? 0.0} / 5",
//                                           style: TextStyle(
//                                             color: subtitleColor,
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       "Experience: ${chef['experience'] ?? 'N/A'} years",
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
import 'package:servable/workers_individuals_profile/chef_individuals.dart';

class ChefProvider with ChangeNotifier {
  List<Map<String, dynamic>> _chefs = [];
  List<Map<String, dynamic>> _filteredChefs = [];

  List<Map<String, dynamic>> get chefs => _filteredChefs;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Embedded translations for error messages
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'fetchError': 'Failed to fetch chefs',
    },
    'ur': {
      'fetchError': 'شیفس لانے میں ناکامی',
    },
  };

  String _translate(String key, String language) {
    return _translations[language]?[key] ?? key;
  }

  Future<void> fetchChefs(String language) async {
    _isLoading = true;
    notifyListeners();
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Worker')
          .where('categories', arrayContains: 'Chef')
          .get();

      _chefs = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return data;
      }).toList();

      _filteredChefs = List.from(_chefs);
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(msg: _translate('fetchError', language));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchChefs(String query) {
    if (query.isEmpty) {
      _filteredChefs = List.from(_chefs);
    } else {
      _filteredChefs = _chefs
          .where((chef) =>
              chef['city'] != null &&
              chef['city'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}

class Chefs extends StatefulWidget {
  const Chefs({super.key});

  @override
  State<Chefs> createState() => _ChefsState();
}

class _ChefsState extends State<Chefs> {
  final TextEditingController _searchController = TextEditingController();

  // Embedded translations for UI elements
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'appTitle': 'Chefs',
      'searchHint': 'Search by City...',
      'noChefsFound': 'No chefs found',
      'experienceLabel': 'Experience: {years} years',
    },
    'ur': {
      'appTitle': 'شیفس',
      'searchHint': 'شہر کے لحاظ سے تلاش کریں...',
      'noChefsFound': 'کوئی شیف نہیں ملا',
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
      final language = Provider.of<LanguageProvider>(context, listen: false).language;
      Provider.of<ChefProvider>(context, listen: false).fetchChefs(language);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chefProvider = Provider.of<ChefProvider>(context);
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
          
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                chefProvider.searchChefs(value);
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
            child: chefProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(greenColor),
                    ),
                  )
                : chefProvider.chefs.isEmpty
                    ? Center(
                        child: Text(
                          _translate('noChefsFound', language),
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(10),
                        itemCount: chefProvider.chefs.length,
                        itemBuilder: (context, index) {
                          var chef = chefProvider.chefs[index];
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
                                          ChefIndividuals(chef: chef),
                                    ),
                                  );
                                },
                                leading: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF00A86B), Colors.teal],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: const CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 30,
                                    child: Icon(
                                      Icons.restaurant,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  chef['name']?.toString() ?? 'No Name',
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
                                          chef['city']?.toString() ?? 'No city',
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
                                          "${chef['rating'] ?? 0.0} / 5",
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
                                          placeholder: chef['experience']?.toString() ?? 'N/A'),
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