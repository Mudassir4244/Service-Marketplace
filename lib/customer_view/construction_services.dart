
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/service_providers/architectures.dart';
import 'package:servable/service_providers/civil_engineers.dart';
import 'package:servable/service_providers/labour.dart';
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

class ConstructionProviders extends StatefulWidget {
  const ConstructionProviders({super.key});

  @override
  State<ConstructionProviders> createState() => _ConstructionProvidersState();
}

class _ConstructionProvidersState extends State<ConstructionProviders> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();

  // Embedded translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'appTitle': 'Construction Services',
      'searchHint': 'Search...',
      'noProvidersFound': 'No construction providers found',
    },
    'ur': {
      'appTitle': 'تعمیراتی خدمات',
      'searchHint': 'تلاش کریں...',
      'noProvidersFound': 'کوئی تعمیراتی فراہم کنندہ نہیں ملا',
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

    // List of all construction providers with localized labels
    final allConstructionProviders = [
      ServiceProvider(
        {'en': 'Labour', 'ur': 'مزدور'},
        "assets/labour.jpeg",
        const Labours(),
      ),
      ServiceProvider(
        {'en': 'Architecture', 'ur': 'آرکنیکچر'},
        "assets/architecture.jpg",
        const Architectures(),
      ),
      ServiceProvider(
        {'en': 'Civil Engineer', 'ur': 'سول انجینئر'},
        "assets/civil_engineer.jpg",
        const CivilEngineers(),
      ),
    ];

    // Filter providers based on search query
    final filteredConstructionProviders = query.isEmpty
        ? allConstructionProviders
        : allConstructionProviders
            .where((provider) => provider.getLabel(language).toLowerCase().contains(query))
            .toList();

    // Map filtered providers to serviceTile widgets
    final providerWidgets = filteredConstructionProviders
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
              // GridView for construction providers
              Expanded(
                child: providerWidgets.isEmpty
                    ? Center(
                        child: Text(
                          _translate('noProvidersFound', language),
                          style: TextStyle(color: textColor, fontSize: 16),
                          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      )
                    : GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 0.75,
                        children: providerWidgets,
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