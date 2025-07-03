
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/theme_provider/themeprovider.dart';

class fashionservice extends ChangeNotifier {
  static const List<String> _categoryNames = [
   
    'Labour',
  
   
  ];

  static const List<String> _categoryImages = [
   
      "assets/labour.jpeg"
  ];

  final List<bool> _checkboxStates = List.generate(_categoryNames.length, (_) => false);
  List<bool> get checkboxStates => _checkboxStates;

   toggleCheckbox(int index) {
    _checkboxStates[index] = !_checkboxStates[index];
    notifyListeners();
  }

  List<Map<String, dynamic>> getSelectedCategories() {
    List<Map<String, dynamic>> selected = [];
    for (int i = 0; i < _checkboxStates.length; i++) {
      if (_checkboxStates[i]) {
        selected.add({
          'name': _categoryNames[i],
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

class fashion extends StatelessWidget {
  const fashion ({super.key});

  @override
  Widget build(BuildContext context) {
    final themeprovider = Provider.of<Themeprovider>(context);
    final checkboxprovider = Provider.of<fashionservice>(context);
    final isDarkMode = themeprovider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Color(0xFFF1FCF7),
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
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
        title: const Text(
          'Fashion Services',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Consumer<fashionservice>(
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
                        fashionservice._categoryNames[index],
                        fashionservice._categoryImages[index],
                        isDarkMode,
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
                final selectedCategories = checkboxprovider.getSelectedCategories();
                if (selectedCategories.isNotEmpty) {
                  // Navigate to WorkerDetail and pass selected categories
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
                    const SnackBar(content: Text('Please select at least one category')),
                  );
                }
              },
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTile(
    BuildContext context,
    fashionservice provider,
    int index,
    String title,
    String imagePath,
    bool isDarkMode,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              ),
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