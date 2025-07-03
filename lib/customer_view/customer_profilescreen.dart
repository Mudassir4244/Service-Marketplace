

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:servable/Inbox/inbox.dart';
import 'package:servable/Screens/category_selection.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/customer_view/homescreen.dart';
import 'package:servable/customer_view/notifcationns.dart';
import 'package:servable/customer_view/services.dart';
import 'package:servable/customer_view/vechical_subcat_setect.dart';
import 'package:servable/customer_view/settings.dart';
import 'package:servable/theme_provider/themeprovider.dart';


class CustomerProvider with ChangeNotifier {
  File? image;
  final ImagePicker _imagePicker = ImagePicker();
  Map<String, dynamic>? _userData;
  String? _role;
  bool _isLoading = false;
  List<Map<String, dynamic>> _selectedCategories = [];
  bool _isDataFetched = false;

  Map<String, dynamic>? get userData => _userData;
  String? get role => _role;
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get selectedCategories => _selectedCategories;

  Future<void> pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    }
  }

  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  int get selectedIndex => _selectedIndex;
  PageController get pageController => _pageController;

  void changeIndex(int index) {
    _selectedIndex = index;
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
    notifyListeners();
  }

  Future<void> updateSubcategories(String categoryName, List<String> subcategories) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final workerRef = FirebaseFirestore.instance.collection('Worker').doc(user.uid);
        DocumentSnapshot workerDoc = await workerRef.get();

        if (workerDoc.exists) {
          Map<String, dynamic> userData = workerDoc.data() as Map<String, dynamic>;
          List<dynamic> categories = userData['categories'] ?? [];

          List<Map<String, dynamic>> updatedCategories = categories.map((cat) {
            if (cat['name'] == categoryName) {
              return {
                'name': cat['name'],
                'subcategories': subcategories,
              };
            }
            return cat as Map<String, dynamic>;
          }).toList();

          if (!categories.any((cat) => cat['name'] == categoryName)) {
            updatedCategories.add({
              'name': categoryName,
              'subcategories': subcategories,
            });
          }

          await workerRef.update({'categories': updatedCategories});
          await fetchUserData();
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error updating subcategories: $e");
    }
    notifyListeners();
  }

  Future<void> updateField(String fieldName, String value) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final customerRef = FirebaseFirestore.instance.collection('Customers').doc(user.uid);
        final workRef = FirebaseFirestore.instance.collection('Worker').doc(user.uid);
        if ((await customerRef.get()).exists) {
          await customerRef.update({fieldName: value});
        } else if ((await workRef.get()).exists) {
          await workRef.update({fieldName: value});
        }
        await fetchUserData();
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.toString()}");
    }
    notifyListeners();
  }

  void updateFromPageView(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  Future<void> fetchUserData() async {
    if (_isDataFetched) return;

    _isLoading = true;
    notifyListeners();

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot customerDoc =
            await FirebaseFirestore.instance.collection('Customers').doc(user.uid).get();
        if (customerDoc.exists) {
          _role = "customer";
          _userData = customerDoc.data() as Map<String, dynamic>?;
        } else {
          DocumentSnapshot workerDoc =
              await FirebaseFirestore.instance.collection('Worker').doc(user.uid).get();
          if (workerDoc.exists) {
            _role = "worker";
            _userData = workerDoc.data() as Map<String, dynamic>?;
          } else {
            _role = null;
            _userData = null;
          }
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      _isLoading = false;
      _isDataFetched = true;
      notifyListeners();
    }
  }

  void setSelectedCategories(List<Map<String, dynamic>> categories) {
    _selectedCategories = categories;
    notifyListeners();
  }

  void removeCategory(int index) {
    if (index >= 0 && index < selectedCategories.length) {
      _selectedCategories.removeAt(index);
      notifyListeners();
    }
  }
}

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<CustomerProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Embedded translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'userProfile': 'User Profile',
      'noUserAvailable': 'No user available',
      'personalInformation': 'Personal Information',
      'name': 'Name',
      'email': 'Email',
      'phone': 'Phone',
      'city': 'City',
      'professionalDetails': 'Professional Details',
      'categories': 'Categories',
      'experience': 'Experience',
      'selectedCategories': 'Selected Categories',
      'becomeWorker': 'Become a Worker',
      'home': 'Home',
      'inbox': 'Inbox',
      'profile': 'Profile',
      'profileName': 'Profile Name',
      'theme': 'Theme',
      'settings': 'Settings',
      'language': 'Language',
      'errorUpdatingSubcategories': 'Error updating subcategories: ',
      'errorUpdatingField': 'Error: ',
    },
    'ur': {
      'userProfile': 'صارف پروفائل',
      'noUserAvailable': 'کوئی صارف دستیاب نہیں',
      'personalInformation': 'ذاتی معلومات',
      'name': 'نام',
      'email': 'ای میل',
      'phone': 'فون',
      'city': 'شہر',
      'professionalDetails': 'پیشہ ورانہ تفصیلات',
      'categories': 'زمرہ جات',
      'experience': 'تجربہ',
      'selectedCategories': 'منتخب زمرہ جات',
      'becomeWorker': 'ورکر بنیں',
      'home': 'ہوم',
      'inbox': 'ان باکس',
      'profile': 'پروفائل',
      'profileName': 'پروفائل کا نام',
      'theme': 'تھیم',
      'settings': 'ترتیبات',
      'language': 'زبان',
      'errorUpdatingSubcategories': 'ذیلی زمرہ جات اپ ڈیٹ کرنے میں خرابی: ',
      'errorUpdatingField': 'خرابی: ',
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

    Future.microtask(() {
      if (mounted && !Provider.of<CustomerProvider>(context, listen: false).isLoading) {
        Provider.of<CustomerProvider>(context, listen: false).fetchUserData();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);
    final themeProvider = Provider.of<Themeprovider>(context);
    final workerprovider = Provider.of<WorkerImagePickerProvider>(context);
    final tabbarprovider = Provider.of<TabBarProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final userData = customerProvider.userData;
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final isUrdu = languageProvider.isUrdu;
    final language = languageProvider.language;

    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          tabbarprovider.changeIndex(0);
          Navigator.push(context, MaterialPageRoute(builder: (context) => Homescreen()));
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : const Color(0xFFF1FCF7),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00A86B), Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            userData?['name'] ?? _translate('userProfile', language),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white,
              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
            ),
            textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
          ),
         
          actions: [
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: Colors.white,
              ),
              onPressed: () {
                themeProvider.toggle_theme();
              },
            ),
          ],
        ),
       
        bottomNavigationBar: Consumer<TabBarProvider>(
          builder: (context, tabbarprovider, child) {
            return BottomNavigationBar(
              currentIndex: 2,
              type: BottomNavigationBarType.fixed,
              backgroundColor: isDark ? Colors.grey[900] : Colors.white,
              selectedItemColor: Colors.teal,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
              items: [
                
                 BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined, size: 30),
                  activeIcon: Icon(Icons.home_rounded, size: 30),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.message_outlined, size: 30),
                  activeIcon: Icon(Icons.message_rounded, size: 30),
                  label: 'Inbox',
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(Icons.notifications_outlined, size: 30),
                //   activeIcon: Icon(Icons.notifications, size: 30),
                //   label: 'Notifications',
                // ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_outlined, size: 30),
                  activeIcon: Icon(Icons.account_circle, size: 30),
                  label: 'Profile',
                ),
              ],
              onTap: (index) {
                tabbarprovider.changeIndex(index);
                switch (index) {
                  case 0:
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Homescreen()));
                    break;
                  case 1:
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Inbox()));
                    break;
                  case 2:
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerProfileScreen()));
                    break;
                }
              },
            );
          },
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: customerProvider.isLoading
              ? Center(child: CircularProgressIndicator(color: const Color(0xFF00A86B)))
              : userData == null
                  ? Center(
                      child: Text(
                        _translate('noUserAvailable', language),
                        style: TextStyle(
                          fontSize: 18,
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                        textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: isUrdu ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            Center(
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [const Color(0xFF00A86B), Colors.teal],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 72,
                                      backgroundColor: Colors.transparent,
                                      child: CircleAvatar(
                                        radius: 70,
                                        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
                                        child: customerProvider.image != null
                                            ? ClipOval(
                                                child: Image.file(
                                                  customerProvider.image!,
                                                  fit: BoxFit.cover,
                                                  width: 140,
                                                  height: 140,
                                                ),
                                              )
                                            : Icon(
                                                Icons.person,
                                                size: 80,
                                                color: isDark ? Colors.white : Colors.black,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        customerProvider.pickImage();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [Color(0xFF00A86B), Colors.teal],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 8,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            Text(
                              _translate('personalInformation', language),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black,
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                              ),
                              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            SizedBox(height: 16),
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              color: isDark ? Colors.grey[900] : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    _buildInfoTile(
                                      title: _translate('name', language),
                                      value: userData['name'] ?? 'N/A',
                                      icon: Icons.person_outline,
                                      isDark: isDark,
                                      isUrdu: isUrdu,
                                    ),
                                    _buildInfoTile(
                                      title: _translate('email', language),
                                      value: userData['email'] ?? 'N/A',
                                      icon: Icons.email_outlined,
                                      isDark: isDark,
                                      isUrdu: isUrdu,
                                    ),
                                    _buildInfoTile(
                                      title: _translate('phone', language),
                                      value: userData['phonenumber'] ?? 'N/A',
                                      icon: Icons.phone_outlined,
                                      isDark: isDark,
                                      isUrdu: isUrdu,
                                    ),
                                    _buildInfoTile(
                                      title: _translate('city', language),
                                      value: userData['city'] ?? 'N/A',
                                      icon: Icons.location_city_outlined,
                                      isDark: isDark,
                                      isUrdu: isUrdu,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (customerProvider.role == "worker") ...[
                              SizedBox(height: 24),
                              Text(
                                _translate('professionalDetails', language),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black,
                                  fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                ),
                                textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                              ),
                              SizedBox(height: 16),
                              Column(
                                children: [
                                  Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    color: isDark ? Colors.grey[900] : Colors.white,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          _buildInfoTile(
                                            title: _translate('categories', language),
                                            value: userData['categories']?.toString() ?? 'N/A',
                                            icon: Icons.category_outlined,
                                            isDark: isDark,
                                            isUrdu: isUrdu,
                                          ),
                                          _buildInfoTile(
                                            title: _translate('experience', language),
                                            value: "${userData['experience'] ?? 'N/A'} years",
                                            icon: Icons.work_outline,
                                            isDark: isDark,
                                            isUrdu: isUrdu,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20 ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 230),
                                      child: Text(
                                        _translate('Reviews', language),
                                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? Colors.grey[900] : Colors.white,
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Text(
          //     'Reviews',
          //     style: TextStyle(
          //       fontSize: 18,
          //       fontWeight: FontWeight.bold,
          //       color: isDark ? Colors.white : Colors.black,
          //     ),
          //   ),
          // ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('Worker')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection('reviews')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: isDark ? Colors.red[300] : Colors.red),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No reviews available'),
                );
              }

              final reviews = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index].data();
                  final reviewerName = review['reviewerName'] as String? ?? 'Anonymous';
                  final rating = (review['rating'] as num?)?.toDouble() ?? 0.0;
                  final comment = review['comment'] as String? ?? 'No comment';

                  return Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Reviewer's name
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.teal,
                                child: Icon(Icons.person ,
                                color: Colors.white,),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                reviewerName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          // 2. Rating stars with number
                          Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: Row(
                              children: [
                                // Yellow stars based on rating
                                Row(
                                  children: List.generate(5, (starIndex) {
                                    return Icon(
                                      starIndex < rating.floor() ? Icons.star : Icons.star_border,
                                      color: starIndex < rating.floor() ? Colors.yellow : Colors.grey,
                                      size: 20,
                                    );
                                  }),
                                ),
                                const SizedBox(width: 8.0),
                                // Rating number (e.g., 5.0 or 3.0)
                                Text(
                                  rating.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          // 3. Comment
                          Padding(
                            padding: const EdgeInsets.only(left: 50),
                            child: Text(
                              comment,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? Colors.grey[500] : Colors.grey[600],
                              ),
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    )
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ],
                            if (customerProvider.selectedCategories.isNotEmpty) ...[
                              SizedBox(height: 24),
                              Text(
                                _translate('selectedCategories', language),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black,
                                  fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                ),
                                textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                              ),
                              SizedBox(height: 16),
                              Wrap(
                                spacing: 12.0,
                                runSpacing: 12.0,
                                direction: isUrdu ? Axis.horizontal : Axis.horizontal,
                                textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                children: List.generate(customerProvider.selectedCategories.length, (index) {
                                  final category = customerProvider.selectedCategories[index];
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: 120,
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: isDark ? Colors.grey[900] : Colors.teal[50],
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: const Color(0xFF00A86B), width: 1.5),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 6,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundImage: AssetImage(category['image']),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              category['name'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: isDark ? Colors.white : Colors.black,
                                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                              ),
                                              textAlign: TextAlign.center,
                                              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: -8,
                                        right: isUrdu ? null : -8,
                                        left: isUrdu ? -8 : null,
                                        child: GestureDetector(
                                          onTap: () {
                                            customerProvider.removeCategory(index);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.redAccent,
                                            ),
                                            padding: EdgeInsets.all(6),
                                            child: Icon(Icons.close, color: Colors.white, size: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ],
                            SizedBox(height: 32),
                            if (customerProvider.role == "customer")
                              Column(
                                children: [
                                  Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      image: DecorationImage(
                                        image: AssetImage('assets/worker.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  GestureDetector(
                                    onTap: () async {
                                      final selectedCategories = await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => CategorySelectionScreen()),
                                      );
                                      if (selectedCategories != null) {
                                        customerProvider.setSelectedCategories(selectedCategories);
                                        await customerProvider.fetchUserData();
                                      }
                                    },
                                    child: Container(
                                      height: 60,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [const Color(0xFF00A86B), Colors.teal],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          _translate('becomeWorker', language),
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                          ),
                                          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
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
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required String title,
    required String value,
    required IconData icon,
    required bool isDark,
    required bool isUrdu,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.teal,
        size: 28,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : Colors.black87,
          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
        ),
        textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          color: isDark ? Colors.white60 : Colors.black54,
          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
        ),
        textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
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