
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:servable/Screens/worker_detail.dart';
// import 'package:servable/customer_view/vechical_subcat_setect.dart';
// import 'package:servable/theme_provider/themeprovider.dart';

// class VehicalProvider extends ChangeNotifier {
//   static const List<String> _categoryNames = [
   
//     'Mechanic',
//     'Car Wash',
//     'Motorcycle Repair',
//     'Towing Services',
   
//   ];

//   static const List<String> _categoryImages = [
   
//     'assets/auto_mechanic.png',
//     'assets/carwash.jpg',
//     'assets/motorcycle_repair.jpg',
//     'assets/towing.jpeg',
   
//   ];

//   final List<bool> _checkboxStates = List.generate(_categoryNames.length, (_) => false);
//   List<bool> get checkboxStates => _checkboxStates;

//    toggleCheckbox(int index) {
//     _checkboxStates[index] = !_checkboxStates[index];
//     notifyListeners();
//   }

//   List<Map<String, dynamic>> getSelectedCategories() {
//     List<Map<String, dynamic>> selected = [];
//     for (int i = 0; i < _checkboxStates.length; i++) {
//       if (_checkboxStates[i]) {
//         selected.add({
//           'name': _categoryNames[i],
//           'image': _categoryImages[i],
//         });
//       }
//     }
//     return selected;
//   }

//   void resetSelections() {
//     for (int i = 0; i < _checkboxStates.length; i++) {
//       _checkboxStates[i] = false;
//     }
//     notifyListeners();
//   }
// }

// class VehicalServiceCategory extends StatelessWidget {
//   const VehicalServiceCategory({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final themeprovider = Provider.of<Themeprovider>(context);
//     final checkboxprovider = Provider.of<VehicalProvider>(context);
//     final isDarkMode = themeprovider.themeMode == ThemeMode.dark;

//     return Scaffold(
//       backgroundColor: Color(0xFFF1FCF7),
//       appBar: AppBar(
//         backgroundColor: isDarkMode ? Colors.black : Colors.white,
//         iconTheme: const IconThemeData(color: Colors.white),
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Color(0xFF00A86B), Colors.teal],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         centerTitle: true,
//         title: const Text(
//           'Vehical Services',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       body: Consumer<VehicalProvider>(
//         builder: (context, checkboxProvider, child) {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(10),
//               child: Column(
//                 children: List.generate(checkboxProvider.checkboxStates.length, (index) {
//                   return Column(
//                     children: [
                      
//                       _buildCategoryTile(
//                         context,
//                         checkboxProvider,
//                         index,
//                         VehicalProvider._categoryNames[index],
//                         VehicalProvider._categoryImages[index],
//                         isDarkMode,
//                       ),
//                       const Divider(thickness: 1, color: Colors.green),
//                     ],
//                   );
//                 }),
//               ),
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(10),
//         child: SizedBox(
//           height: kToolbarHeight,
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(30),
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF00A86B), Colors.teal],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 backgroundColor: Colors.transparent,
//                 shadowColor: Colors.transparent,
//               ),
//               onPressed: () {
//                 final selectedCategories = checkboxprovider.getSelectedCategories();
//                 if (selectedCategories.isNotEmpty) {
//                   // Navigate to WorkerDetail and pass selected categories
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => WorkerDetail(
//                         selectedCategories: selectedCategories,
//                       ),
//                     ),
//                   );
//                   // Optionally reset selections
//                   // checkboxprovider.resetSelections();
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Please select at least one category')),
//                   );
//                 }
//               },
//               child: const Text(
//                 'Continue',
//                 style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoryTile(
//     BuildContext context,
//     VehicalProvider provider,
//     int index,
//     String title,
//     String imagePath,
//     bool isDarkMode,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Flexible(
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.1,
//               decoration: BoxDecoration(
//                 image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: Colors.green, width: 2),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             flex: 2,
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 21,
//                 color: isDarkMode ? Colors.white : Colors.black,
//               ),
//             ),
//           ),
//           title== 'Mechanic'?IconButton(onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>VechicalSubcatSetection()));
//           }, icon: Icon(Icons.arrow_forward_ios)):
         
  

//           Checkbox(
//             value: provider.checkboxStates[index],
//             onChanged: (value) => provider.toggleCheckbox(index),
//             activeColor: Colors.teal,
//             checkColor: Colors.white,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/customer_view/vechical_subcat_setect.dart';
import 'package:servable/theme_provider/themeprovider.dart';



class VehicalProvider extends ChangeNotifier {
  static const Map<String, List<String>> _categoryTranslations = {
    'en': [
      'Mechanic',
      'Car Wash',
      'Motorcycle Repair',
      'Towing Services',
    ],
    'ur': [
      'میکینک',
      'کار واش',
      'موٹرسائیکل کی مرمت',
      'ٹوئنگ سروسز',
    ],
  };

  static const List<String> _categoryImages = [
    'assets/auto_mechanic.png',
    'assets/carwash.jpg',
    'assets/motorcycle_repair.jpg',
    'assets/towing.jpeg',
  ];

  final List<bool> _checkboxStates = List.generate(_categoryTranslations['en']!.length, (_) => false);
  List<bool> get checkboxStates => _checkboxStates;

  toggleCheckbox(int index) {
    _checkboxStates[index] = !_checkboxStates[index];
    notifyListeners();
  }

  List<Map<String, dynamic>> getSelectedCategories(String language) {
    List<Map<String, dynamic>> selected = [];
    for (int i = 0; i < _checkboxStates.length; i++) {
      if (_checkboxStates[i]) {
        selected.add({
          'name': _categoryTranslations[language]![i],
          'name_en': _categoryTranslations['en']![i], // Store English name for consistency
          'image': _categoryImages[i],
        });
      }
    }
    return selected;
  }

  void resetSelections() {
    for (int i = 0; i < _checkboxStates.length; i++) {
      _checkboxStates[i] = false;
    }
    notifyListeners();
  }
}

class VehicalServiceCategory extends StatelessWidget {
   VehicalServiceCategory({super.key});

  // Embedded translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'vehicleServices': 'Vehicle Services',
      'continueButton': 'Continue',
      'selectCategoryError': 'Please select at least one category',
    },
    'ur': {
      'vehicleServices': 'گاڑیوں کی خدمات',
      'continueButton': 'جاری رکھیں',
      'selectCategoryError': 'براہ کرم کم از کم ایک زمرہ منتخب کریں',
    },
  };

  String _translate(String key, String language) {
    return _translations[language]?[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final themeprovider = Provider.of<Themeprovider>(context);
    final checkboxprovider = Provider.of<VehicalProvider>(context);
    final languageprovider = Provider.of<LanguageProvider>(context);
    final isDarkMode = themeprovider.themeMode == ThemeMode.dark;
    final isUrdu = languageprovider.isUrdu;
    final language = languageprovider.language;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : const Color(0xFFF1FCF7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00A86B), Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          _translate('vehicleServices', language),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
          ),
          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
        ),
        actions: [
          // EasyPaisa-styled toggle button
          // GestureDetector(
          //   onTap: () {
          //     languageprovider.toggleLanguage();
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
      body: Consumer<VehicalProvider>(
        builder: (context, checkboxProvider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: List.generate(checkboxProvider.checkboxStates.length, (index) {
                  return Column(
                    children: [
                      _buildCategoryTile(
                        context,
                        checkboxProvider,
                        index,
                        VehicalProvider._categoryTranslations[language]![index],
                        VehicalProvider._categoryImages[index],
                        isDarkMode,
                        isUrdu,
                      ),
                      const Divider(thickness: 1, color: Colors.green),
                    ],
                  );
                }),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: kToolbarHeight,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                colors: [Color(0xFF00A86B), Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              onPressed: () {
                final selectedCategories = checkboxprovider.getSelectedCategories(language);
                if (selectedCategories.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkerDetail(
                        selectedCategories: selectedCategories,
                      ),
                    ),
                  );
                  // Optionally reset selections
                  // checkboxprovider.resetSelections();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(_translate('selectCategoryError', language))),
                  );
                }
              },
              child: Text(
                _translate('continueButton', language),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                ),
                textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTile(
    BuildContext context,
    VehicalProvider provider,
    int index,
    String title,
    String imagePath,
    bool isDarkMode,
    bool isUrdu,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Flexible(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green, width: 2),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21,
                color: isDarkMode ? Colors.white : Colors.black,
                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
              ),
              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
            ),
          ),
          title == (isUrdu ? 'میکینک' : 'Mechanic')
              ? IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VehicleSubcatSelection()));
                  },
                  icon: Icon(
                    isUrdu ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
                    color: Colors.teal,
                  ),
                )
              : Checkbox(
                  value: provider.checkboxStates[index],
                  onChanged: (value) => provider.toggleCheckbox(index),
                  activeColor: Colors.teal,
                  checkColor: Colors.white,
                ),
        ],
      ),
    );
  }
}