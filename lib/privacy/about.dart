import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/theme_provider/themeprovider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _appVersion = '1.0.0'; // Placeholder, will be updated dynamically

  // Translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'about': 'About',
      'appInfo': 'App Information',
      'appName': 'Servable',
      'version': 'Version',
      'mission': 'Our Mission',
      'missionDesc': 'Servable connects customers with trusted service providers, offering a seamless experience for vehicle, construction, and home services.',
      'team': 'Our Team',
      'teamDesc': 'We are a dedicated team of developers and designers passionate about building solutions that empower communities.',
      'connect': 'Connect With Us',
      'website': 'Visit Website',
      'twitter': 'Follow on Twitter',
      'facebook': 'Like on Facebook',
      'linkError': 'Failed to open link',
    },
    'ur': {
      'about': 'کے بارے میں',
      'appInfo': 'ایپ کی معلومات',
      'appName': 'سرویبل',
      'version': 'ورژن',
      'mission': 'ہمارا مشن',
      'missionDesc': 'سرویبل صارفین کو قابل اعتماد سروس فراہم کنندگان سے جوڑتا ہے، گاڑیوں، تعمیرات، اور گھریلو خدمات کے لیے ایک بغیر کسی رکاوٹ کے تجربہ پیش کرتا ہے۔',
      'team': 'ہماری ٹیم',
      'teamDesc': 'ہم ڈویلپرز اور ڈیزائنرز کی ایک سرشار ٹیم ہیں جو کمیونٹیز کو بااختیار بنانے والے حل بنانے کے شوقین ہیں۔',
      'connect': 'ہم سے رابطہ کریں',
      'website': 'ویب سائٹ ملاحظہ کریں',
      'twitter': 'ٹوئٹر پر فالو کریں',
      'facebook': 'فیس بک پر لائک کریں',
      'linkError': 'لنک کھولنے میں ناکام',
    },
  };

  String _translate(String key, String language) {
    return _translations[language]?[key] ?? key;
  }

  @override
  void initState() {
    super.initState();
    _fetchAppVersion();
  }

  // Fetch app version dynamically
  Future<void> _fetchAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  // Launch URL for social media or website
  Future<void> _launchUrl(String url) async {
    final language = Provider.of<LanguageProvider>(context, listen: false).language;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_translate('linkError', language)),
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
          _translate('about', language),
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
                // App Information
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
                      padding: EdgeInsets.all(maxWidth * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          Text(
                            _translate('appInfo', language),
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: maxWidth * 0.05,
                              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                            ),
                          ),
                          SizedBox(height: maxHeight * 0.02),
                          Row(
                            textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                            children: [
                              const Icon(Icons.info, color: Color(0xFF00A86B)),
                              SizedBox(width: maxWidth * 0.03),
                              Text(
                                '${_translate('appName', language)} ${_translate('version', language)} $_appVersion',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: maxWidth * 0.045,
                                  fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: maxHeight * 0.03),

                // Mission Statement
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
                      padding: EdgeInsets.all(maxWidth * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          Text(
                            _translate('mission', language),
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: maxWidth * 0.05,
                              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                            ),
                          ),
                          SizedBox(height: maxHeight * 0.01),
                          Text(
                            _translate('missionDesc', language),
                            style: TextStyle(
                              color: textColor.withOpacity(0.7),
                              fontSize: maxWidth * 0.045,
                              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: maxHeight * 0.03),

                // Team Section
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
                      padding: EdgeInsets.all(maxWidth * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          Text(
                            _translate('team', language),
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: maxWidth * 0.05,
                              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                            ),
                          ),
                          SizedBox(height: maxHeight * 0.01),
                          Text(
                            _translate('teamDesc', language),
                            style: TextStyle(
                              color: textColor.withOpacity(0.7),
                              fontSize: maxWidth * 0.045,
                              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: maxHeight * 0.03),

                // Connect With Us
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
                      padding: EdgeInsets.all(maxWidth * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          Text(
                            _translate('connect', language),
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: maxWidth * 0.05,
                              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                            ),
                          ),
                          SizedBox(height: maxHeight * 0.02),
                          ListTile(
                            leading: const Icon(Icons.language, color: Color(0xFF00A86B)),
                            title: Text(
                              _translate('website', language),
                              style: TextStyle(
                                color: textColor,
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward, color: Color(0xFF00A86B)),
                            onTap: () => _launchUrl('https://example.com'), // Replace with actual website
                          ),
                          ListTile(
                            leading: const Icon(Icons.alternate_email, color: Color(0xFF00A86B)),
                            title: Text(
                              _translate('twitter', language),
                              style: TextStyle(
                                color: textColor,
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward, color: Color(0xFF00A86B)),
                            onTap: () => _launchUrl('https://twitter.com/example'), // Replace with actual Twitter
                          ),
                          ListTile(
                            leading: const Icon(Icons.facebook, color: Color(0xFF00A86B)),
                            title: Text(
                              _translate('facebook', language),
                              style: TextStyle(
                                color: textColor,
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward, color: Color(0xFF00A86B)),
                            onTap: () => _launchUrl('https://facebook.com/example'), // Replace with actual Facebook
                          ),
                        ],
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