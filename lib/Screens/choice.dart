
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/category_selection.dart';
import 'package:servable/Screens/loginscreen.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/customer_view/registration.dart';
import 'package:servable/theme_provider/themeprovider.dart';


Future<String?> getUserRole(String uid) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var customerDoc = await firestore.collection('Customers').doc(uid).get();
  if (customerDoc.exists) return 'Customer';
  var workerDoc = await firestore.collection('Worker').doc(uid).get();
  if (workerDoc.exists) return 'Worker';
  return null;
}

class ChoiceScreen extends StatefulWidget {
  const ChoiceScreen({super.key});

  @override
  State<ChoiceScreen> createState() => _ChoiceState();
}

class _ChoiceState extends State<ChoiceScreen> {
  // Embedded translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'appTitle': 'Servable',
      'chooseRole': 'Choose Your Role',
      'selectRole': 'Select Your Role',
      'rolePrompt': 'Are you a Customer or a Worker?',
      'customer': 'Customer',
      'worker': 'Worker',
      'alreadyHaveAccount': 'Already have an account?',
      'login': 'Login',
      'select': 'Select',
    },
    'ur': {
      'appTitle': 'سرو ایبل',
      'chooseRole': 'اپنا کردار منتخب کریں',
      'selectRole': 'اپنا کردار منتخب کریں',
      'rolePrompt': 'کیا آپ صارف ہیں یا ورکر؟',
      'customer': 'صارف',
      'worker': 'ورکر',
      'alreadyHaveAccount': 'پہلے سے اکاؤنٹ ہے؟',
      'login': 'لاگ ان',
      'select': 'منتخب کریں',
    },
  };

  String _translate(String key, String language, [Map<String, String>? replacements]) {
    String text = _translations[language]?[key] ?? key;
    if (replacements != null) {
      replacements.forEach((k, v) => text = text.replaceAll('{$k}', v));
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final checkboxProvider = Provider.of<CheckboxProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final isUrdu = languageProvider.isUrdu;
    final language = languageProvider.language;
    final bgColor = isDark ? Colors.black : const Color(0xFFF1FCF7);
    final textColor = isDark ? Colors.white : Colors.black87;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 4,
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
        title: Text(
          _translate('chooseRole', language),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
          ),
          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
        ),
        actions: [
          // EasyPaisa-styled toggle button
          GestureDetector(
            onTap: () {
              languageProvider.toggleLanguage();
            },
            child: Container(
              width: 80,
              height: 36,
              margin: EdgeInsets.only(right: 8),
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
                        color: Colors.teal,
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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.05),
            // Logo Section
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 500),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00A86B), Colors.teal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/logo.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            // Header Text
            Text(
              _translate('selectRole', language),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
              ),
              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              _translate('rolePrompt', language),
              style: TextStyle(
                fontSize: 16,
                color: textColor.withOpacity(0.7),
                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
              ),
              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
            ),
            SizedBox(height: screenHeight * 0.04),
            // Role Selection Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRoleCard(
                  image: 'assets/customer.jpg',
                  title: _translate('customer', language),
                  isDark: isDark,
                  textColor: textColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Registration()),
                    );
                  },
                  width: screenWidth * 0.42,
                  height: 300,
                  isUrdu: isUrdu,
                ),
                SizedBox(width: screenWidth * 0.04),
                _buildRoleCard(
                  image: 'assets/worker.jpg',
                  title: _translate('worker', language),
                  isDark: isDark,
                  textColor: textColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WorkerDetail()),
                    );
                  },
                  width: screenWidth * 0.42,
                  height: 300,
                  isUrdu: isUrdu,
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),
            // Login Prompt
            Text(
              _translate('alreadyHaveAccount', language),
              style: TextStyle(
                fontSize: 20,
                color: textColor,
                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
              ),
              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
            ),
            SizedBox(height: screenHeight * 0.02),
            // Login Button
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Loginpage()),
                  );
                },
                child: Container(
                  width: screenWidth * 0.6,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00A86B), Colors.teal],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _translate('login', language),
                      style: TextStyle(
                        fontSize: 22,
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
            SizedBox(height: screenHeight * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String image,
    required String title,
    required bool isDark,
    required Color textColor,
    required VoidCallback onTap,
    required double width,
    required double height,
    required bool isUrdu,
  }) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: 500),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(
                    image,
                    height: height * 0.6,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                      ),
                      textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: width * 0.7,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00A86B), Colors.teal],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      _translate('select', Provider.of<LanguageProvider>(context, listen: false).language),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                      ),
                      textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}