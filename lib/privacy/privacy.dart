import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/privacy/privacy_policy.dart';
import 'package:servable/theme_provider/themeprovider.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _dataSharingEnabled = true; // Placeholder for data sharing preference
  bool _notificationsEnabled = true; // Placeholder for notification preference

  // Translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'privacySettings': 'Privacy Settings',
      'dataSharing': 'Data Sharing',
      'dataSharingDesc': 'Allow sharing of anonymized usage data to improve the app',
      'privacyPolicy': 'Privacy Policy',
      'privacyPolicyDesc': 'View our privacy policy',
      'notifications': 'Push Notifications',
      'notificationsDesc': 'Receive notifications for app updates and alerts',
      'openLinkError': 'Failed to open privacy policy',
      'settingsSaved': 'Settings saved successfully',
    },
    'ur': {
      'privacySettings': 'رازداری کی ترتیبات',
      'dataSharing': 'ڈیٹا شیئرنگ',
      'dataSharingDesc': 'ایپ کو بہتر بنانے کے لیے گمنام استعمال کے ڈیٹا کی شیئرنگ کی اجازت دیں',
      'privacyPolicy': 'رازداری کی پالیسی',
      'privacyPolicyDesc': 'ہماری رازداری کی پالیسی دیکھیں',
      'notifications': 'پش نوٹیفکیشنز',
      'notificationsDesc': 'ایپ اپ ڈیٹس اور الرٹس کے لیے نوٹیفکیشنز وصول کریں',
      'openLinkError': 'رازداری کی پالیسی کھولنے میں ناکام',
      'settingsSaved': 'ترتیبات کامیابی سے محفوظ ہو گئیں',
    },
  };

  String _translate(String key, String language) {
    return _translations[language]?[key] ?? key;
  }

  // Placeholder function to save settings (replace with actual backend logic)
  void _saveSettings() {
    final language = Provider.of<LanguageProvider>(context, listen: false).language;
    // TODO: Implement actual saving logic (e.g., to Firebase or local storage)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_translate('settingsSaved', language)),
        backgroundColor: const Color(0xFF00A86B),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Launch privacy policy URL
  Future<void> _launchPrivacyPolicy() async {
    final language = Provider.of<LanguageProvider>(context, listen: false).language;
    const url = 'https://example.com/privacy'; // Replace with actual URL
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_translate('openLinkError', language)),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
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
          _translate('privacySettings', language),
          style: TextStyle(
            color: textColor,
            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFF00A86B),
          size: 28,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
              children: [
                // Data Sharing Toggle
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: Card(
                    elevation: 4,
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
                      child: ListTile(
                        leading: const Icon(Icons.share, color: Color(0xFF00A86B)),
                        title: Text(
                          _translate('dataSharing', language),
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                          ),
                        ),
                        subtitle: Text(
                          _translate('dataSharingDesc', language),
                          style: TextStyle(
                            color: textColor.withOpacity(0.7),
                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                          ),
                        ),
                        trailing: Switch(
                          value: _dataSharingEnabled,
                          activeColor: const Color(0xFF00A86B),
                          onChanged: (value) {
                            setState(() => _dataSharingEnabled = value);
                            _saveSettings();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: maxHeight * 0.03),

                // Privacy Policy
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: Card(
                    elevation: 4,
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
                      child: ListTile(
                        leading: const Icon(Icons.policy, color: Color(0xFF00A86B)),
                        title: Text(
                          _translate('privacyPolicy', language),
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                          ),
                        ),
                        subtitle: Text(
                          _translate('privacyPolicyDesc', language),
                          style: TextStyle(
                            color: textColor.withOpacity(0.7),
                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward, color: Color(0xFF00A86B)),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyPolicyScreen()));
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: maxHeight * 0.03),

                // Notification Preferences
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: Card(
                    elevation: 4,
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
                      child: ListTile(
                        leading: const Icon(Icons.notifications, color: Color(0xFF00A86B)),
                        title: Text(
                          _translate('notifications', language),
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                          ),
                        ),
                        subtitle: Text(
                          _translate('notificationsDesc', language),
                          style: TextStyle(
                            color: textColor.withOpacity(0.7),
                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                          ),
                        ),
                        trailing: Switch(
                          value: _notificationsEnabled,
                          activeColor: const Color(0xFF00A86B),
                          onChanged: (value) {
                            setState(() => _notificationsEnabled = value);
                            _saveSettings();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}