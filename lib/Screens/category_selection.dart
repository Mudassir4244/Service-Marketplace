
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/theme_provider/themeprovider.dart';



class CheckboxProvider extends ChangeNotifier {
  static const Map<String, List<String>> _categoryTranslations = {
    'en': [
      'Plumber',
      'Carpenter',
      'Electrician',
      'Labour',
      'Chef',
      'Gardener',
      'Tailor',
      'Home Cleaning',
      'Pest Control',
      'Movers & Packers',
      'Event Decoration',
      'CCTV Installation',
    ],
    'ur': [
      'پلمبر',
      'کارپینٹر',
      'الیکٹریشن',
      'مزدور',
      'شیف',
      'باغبان',
      'درزی',
      'گھر کی صفائی',
      'کیڑے مکوڑوں کا کنٹرول',
      'منتقلی اور پیکنگ',
      'تقریب کی سجاوٹ',
      'سی سی ٹی وی تنصیب',
    ],
  };

  static const List<String> _categoryImages = [
    'assets/plumber.jpeg',
    'assets/carpenter.jpg',
    'assets/electrician_2.jpg',
    'assets/labour.jpeg',
    'assets/chef.jpeg',
    'assets/gardener.jpeg',
    'assets/tailor.png',
    'assets/cleaning.jpeg',
    'assets/pestcontrol.jpeg',
    'assets/movers.png',
    'assets/eventdecoration.jpeg',
    'assets/cctv.jpeg',
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

class CategorySelectionScreen extends StatelessWidget {
   CategorySelectionScreen({super.key});

  // Embedded translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'homeServices': 'Home Services',
      'continueButton': 'Continue',
      'selectCategoryError': 'Please select at least one category',
    },
    'ur': {
      'homeServices': 'گھریلو خدمات',
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
    final checkboxprovider = Provider.of<CheckboxProvider>(context);
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
          _translate('homeServices', language),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
          ),
          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
        ),
        actions: [
          // // EasyPaisa-styled toggle button
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
      body: Consumer<CheckboxProvider>(
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
                        CheckboxProvider._categoryTranslations[language]![index],
                        CheckboxProvider._categoryImages[index],
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
    CheckboxProvider provider,
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
          Checkbox(
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