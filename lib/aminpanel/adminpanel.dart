import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/category_selection.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/aminpanel/addcategory.dart';
import 'package:servable/aminpanel/customerscreen.dart';
import 'package:servable/aminpanel/feedbackscreen.dart';
import 'package:servable/aminpanel/reportedproblemscreen.dart';
import 'package:servable/customer_view/allworker.dart';

import 'package:servable/theme_provider/themeprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Adminpanel extends StatefulWidget {
  const Adminpanel({super.key});

  @override
  State<Adminpanel> createState() => _AdminpanelState();
}

class _AdminpanelState extends State<Adminpanel> {
  // Translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'adminPanel': 'Admin Panel',
      'allWorkers': 'All Workers',
      'addCategory': 'Add Category',
      'customers': 'Customers',
      'settings': 'Settings',
      'reportedProblems': 'Reported Problems',
      'feedback': 'Feedback',
      'logout': 'Logout',
      'loggedOut': 'Logged out successfully',
      'settingsComingSoon': 'Settings feature coming soon!',
    },
    'ur': {
      'adminPanel': 'ایڈمن پینل',
      'allWorkers': 'تمام ورکرز',
      'addCategory': 'کیٹیگری شامل کریں',
      'customers': 'صارفین',
      'settings': 'ترتیبات',
      'reportedProblems': 'رپورٹ کردہ مسائل',
      'feedback': 'رائے',
      'logout': 'لاگ آؤٹ',
      'loggedOut': 'کامیابی سے لاگ آؤٹ ہو گیا',
      'settingsComingSoon': 'ترتیبات کی خصوصیت جلد آ رہی ہے!',
    },
  };

  String _translate(String key, String language) {
    return _translations[language]?[key] ?? key;
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

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          _translate('adminPanel', language),
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
          ),
        ),
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFF00A86B),
          size: 28,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_translate('loggedOut', language)),
                  backgroundColor: const Color(0xFF00A86B),
                ),
              );
              // Navigate to login screen or handle post-logout
            },
            tooltip: _translate('logout', language),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;

          return Padding(
            padding: EdgeInsets.all(maxWidth * 0.04),
            child: GridView.count(
              crossAxisCount: maxWidth > 600 ? 3 : 2, // Responsive grid
              crossAxisSpacing: maxWidth * 0.04,
              mainAxisSpacing: maxHeight * 0.02,
              childAspectRatio: 1.2,
              children: [
                _buildAdminCard(
                  context,
                  icon: Icons.people,
                  title: _translate('allWorkers', language),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AllWorkerData()),
                  ),
                  textColor: textColor,
                  isDark: isDark,
                  isUrdu: isUrdu,
                ),
                _buildAdminCard(
                  context,
                  icon: Icons.category,
                  title: _translate('addCategory', language),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Addcategory()),
                  ),
                  textColor: textColor,
                  isDark: isDark,
                  isUrdu: isUrdu,
                ),
                _buildAdminCard(
                  context,
                  icon: Icons.person,
                  title: _translate('customers', language),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const customerfetching()),
                  ),
                  textColor: textColor,
                  isDark: isDark,
                  isUrdu: isUrdu,
                ),
                _buildAdminCard(
                  context,
                  icon: Icons.report_problem,
                  title: _translate('reportedProblems', language),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  ReportedProblemsScreen()),
                  ),
                  textColor: textColor,
                  isDark: isDark,
                  isUrdu: isUrdu,
                ),
                _buildAdminCard(
                  context,
                  icon: Icons.feedback,
                  title: _translate('feedback', language),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  FeedbackScreen()),
                  ),
                  textColor: textColor,
                  isDark: isDark,
                  isUrdu: isUrdu,
                ),
                _buildAdminCard(
                  context,
                  icon: Icons.settings,
                  title: _translate('settings', language),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_translate('settingsComingSoon', language)),
                        backgroundColor: const Color(0xFF00A86B),
                      ),
                    );
                  },
                  textColor: textColor,
                  isDark: isDark,
                  isUrdu: isUrdu,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color textColor,
    required bool isDark,
    required bool isUrdu,
  }) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 500),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                isDark ? Colors.grey[800]! : Colors.white,
                isDark ? Colors.grey[850]! : const Color(0xFFF1FCF7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: const Color(0xFF00A86B),
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}