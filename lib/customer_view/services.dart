
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/customer_view/vechical_subcat_setect.dart';
import 'package:servable/service_providers/carpenters.dart';
import 'package:servable/service_providers/cctv_installation.dart';
import 'package:servable/service_providers/chefs.dart';
import 'package:servable/service_providers/electrician_profile.dart';
import 'package:servable/service_providers/eventdecoration.dart';
import 'package:servable/service_providers/gerdeners.dart';
import 'package:servable/service_providers/homecleaners.dart';
import 'package:servable/service_providers/movers.dart';
import 'package:servable/service_providers/pestcontrol.dart';
import 'package:servable/service_providers/plumbers_profiles.dart';
import 'package:servable/theme_provider/themeprovider.dart';


class TabBarProvider with ChangeNotifier {
  int _selectedIndex = 0;
  String _searchQuery = '';

  int get selectedIndex => _selectedIndex;
  String get searchQuery => _searchQuery;

  void changeIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void clearSearchQuery() {
    _searchQuery = '';
    notifyListeners();
  }
}

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _searchController = TextEditingController();

  // Embedded translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'servicesTitle': 'Services',
      'searchHint': 'Search Services',
      'noServicesFound': 'No services found',
      'plumber': 'Plumber',
      'carpenter': 'Carpenter',
      'electrician': 'Electrician',
      'chef': 'Chef',
      'gardener': 'Gardener',
      'cleaning': 'Cleaning',
      'pestControl': 'Pest Control',
      'movers': 'Movers',
      'eventDecoration': 'Event Decoration',
      'cctvInstallation': 'CCTV Installation',
      'vehicleRepair': 'Vehicle Repair',
    },
    'ur': {
      'servicesTitle': 'خدمات',
      'searchHint': 'خدمات تلاش کریں',
      'noServicesFound': 'کوئی خدمات نہیں ملیں',
      'plumber': 'پلمبر',
      'carpenter': 'بڑھئی',
      'electrician': 'الیکٹریشن',
      'chef': 'شیف',
      'gardener': 'باغبان',
      'cleaning': 'صفائی',
      'pestControl': 'کیڑوں پر قابو',
      'movers': 'منتقلی',
      'eventDecoration': 'تقریب کی سجاوٹ',
      'cctvInstallation': 'سی سی ٹی وی تنصیب',
      'vehicleRepair': 'گاڑیوں کی مرمت',
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
      Provider.of<TabBarProvider>(context, listen: false)
          .updateSearchQuery(_searchController.text);
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

    // Service list with translations and Vehicle Repair
    final List<Map<String, dynamic>> services = [
      {
        'labelKey': 'plumber',
        'imgPath': 'assets/plumber.jpeg',
        'page': const Plumbers(),
      },
      {
        'labelKey': 'carpenter',
        'imgPath': 'assets/carpenter.jpg',
        'page': const Carpenters(),
      },
      {
        'labelKey': 'electrician',
        'imgPath': 'assets/electrician_2.jpg',
        'page': const Electricians(),
      },
      {
        'labelKey': 'chef',
        'imgPath': 'assets/chef.jpeg',
        'page': const Chefs(),
      },
      {
        'labelKey': 'gardener',
        'imgPath': 'assets/gardener.jpeg',
        'page': const Gardeners(),
      },
      {
        'labelKey': 'cleaning',
        'imgPath': 'assets/cleaning.jpeg',
        'page': const Cleaners(),
      },
      {
        'labelKey': 'pestControl',
        'imgPath': 'assets/pestcontrol.jpeg',
        'page': PestControllers(),
      },
      {
        'labelKey': 'movers',
        'imgPath': 'assets/movers.png',
        'page': const Movers(),
      },
      {
        'labelKey': 'eventDecoration',
        'imgPath': 'assets/eventdecoration.jpeg',
        'page': eventmanagement(),
      },
      {
        'labelKey': 'cctvInstallation',
        'imgPath': 'assets/cctv.jpeg',
        'page': const ccctvinstallers(),
      },
      
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF00A86B), Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          _translate('servicesTitle', language),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
            letterSpacing: 1.2,
            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
          ),
          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
        ),
      ),
      
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Consumer<TabBarProvider>(
                  builder: (context, tabBarProvider, child) {
                    return TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: _translate('searchHint', language),
                        hintStyle: TextStyle(
                          color: textColor.withOpacity(0.6),
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                        prefixIcon: Icon(Icons.search, color: textColor),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: textColor),
                                onPressed: () {
                                  _searchController.clear();
                                  tabBarProvider.clearSearchQuery();
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
                      style: TextStyle(
                        color: textColor,
                        fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                      ),
                      textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // GridView for services
              Expanded(
                child: Consumer<TabBarProvider>(
                  builder: (context, tabBarProvider, child) {
                    // Filter services based on search query
                    final filteredServices = tabBarProvider.searchQuery.isEmpty
                        ? services
                        : services.where((service) {
                            final label = _translate(service['labelKey'] as String, language);
                            return label.toLowerCase().contains(tabBarProvider.searchQuery);
                          }).toList();

                    return filteredServices.isEmpty
                        ? Center(
                            child: Text(
                              _translate('noServicesFound', language),
                              style: TextStyle(
                                color: textColor,
                                fontSize: 16,
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                              ),
                              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                            ),
                          )
                        : GridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            childAspectRatio: 0.75,
                            children: filteredServices.map((service) {
                              return serviceTile(
                                context,
                                _translate(service['labelKey'] as String, language),
                                service['imgPath'] as String,
                                service['page'] as Widget,
                              );
                            }).toList(),
                          );
                  },
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
    final languageProvider = Provider.of<LanguageProvider>(context);
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