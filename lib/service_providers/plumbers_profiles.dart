
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/theme_provider/themeprovider.dart';
import 'package:servable/workers_individuals_profile/plumber_individual.dart';

class PlumberProvider with ChangeNotifier {
  List<Map<String, dynamic>> _plumbers = [];
  List<Map<String, dynamic>> _filteredPlumbers = [];

  List<Map<String, dynamic>> get plumbers => _filteredPlumbers;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void fetchPlumbers() async {
    _isLoading = true;
    notifyListeners();
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Worker')
          .where('categories', arrayContains: 'Plumber')
          .get();

      _plumbers = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['uid'] = doc.id;
        return data;
      }).toList();

      _filteredPlumbers = List.from(_plumbers);
      notifyListeners();
    } catch (error) {
      Fluttertoast.showToast(msg: "Error: ${error.toString()}");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchPlumbers(String query) {
    if (query.isEmpty) {
      _filteredPlumbers = List.from(_plumbers);
    } else {
      _filteredPlumbers = _plumbers
          .where((plumber) =>
              plumber['city'] != null &&
              plumber['city'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}

class Plumbers extends StatefulWidget {
  const Plumbers({super.key});

  @override
  State<Plumbers> createState() => _PlumbersState();
}

class _PlumbersState extends State<Plumbers> {
  final TextEditingController _searchController = TextEditingController();

  // Embedded translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'appTitle': 'Plumbers',
      'searchHint': 'Search by City...',
      'noPlumbersFound': 'No plumbers found',
      'experienceLabel': 'Experience: {years} years',
      'fetchError': 'Failed to fetch plumbers',
    },
    'ur': {
      'appTitle': 'پلمبرز',
      'searchHint': 'شہر کے لحاظ سے تلاش کریں...',
      'noPlumbersFound': 'کوئی پلمبر نہیں ملا',
      'experienceLabel': 'تجربہ: {years} سال',
      'fetchError': 'پلمبرز لانے میں ناکامی',
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
      Provider.of<PlumberProvider>(context, listen: false).fetchPlumbers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final plumberProvider = Provider.of<PlumberProvider>(context);
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
        centerTitle: true,
        title: Text(
          _translate('appTitle', language),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
          ),
          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: plumberProvider.searchPlumbers,
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
            child: plumberProvider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(greenColor),
                    ),
                  )
                : plumberProvider.plumbers.isEmpty
                    ? Center(
                        child: Text(
                          _translate('noPlumbersFound', language),
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: plumberProvider.plumbers.length,
                        itemBuilder: (context, index) {
                          var plumber = plumberProvider.plumbers[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 4,
                            color: cardColor,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(15),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlumberIndividual(plumber: plumber),
                                  ),
                                );
                              },
                              leading: CircleAvatar(
                                backgroundColor: greenColor.withOpacity(0.8),
                                radius: 30,
                                child: const Icon(Icons.person, size: 30, color: Colors.white),
                              ),
                              title: Text(
                                plumber['name'] ?? 'No Name',
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
                                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        plumber['city'] ?? 'Unknown',
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
                                      const Icon(Icons.star, size: 16, color: Colors.orange),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${plumber['rating'] ?? 0.0} / 5",
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
                                        placeholder: plumber['experience']?.toString() ?? 'N/A'),
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
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}