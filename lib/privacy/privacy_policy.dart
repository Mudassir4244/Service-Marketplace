import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/theme_provider/themeprovider.dart';

class PrivacyPolicyScreen extends StatelessWidget {
   PrivacyPolicyScreen({super.key});

  // Translations for Privacy Policy content
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'privacyPolicy': 'Privacy Policy',
      'lastUpdated': 'Last Updated: June 17, 2025',
      'intro': 'Welcome to Servable. We value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard your data.',
      'dataCollection': 'Data Collection',
      'dataCollectionDesc': 'We collect information you provide directly, such as your email and profile details, and usage data to improve our services.',
      'dataUsage': 'Data Usage',
      'dataUsageDesc': 'Your data is used to personalize your experience, provide customer support, and enhance app functionality.',
      'dataSharing': 'Data Sharing',
      'dataSharingDesc': 'We do not sell your data. We may share anonymized data with trusted partners to improve our services.',
      'yourRights': 'Your Rights',
      'yourRightsDesc': 'You can access, update, or delete your data by contacting us. You may also opt out of data sharing in the Privacy Settings.',
      'contactUs': 'Contact Us',
      'contactUsDesc': 'For questions about this Privacy Policy, contact us at support@servable.com.',
    },
    'ur': {
      'privacyPolicy': 'رازداری کی پالیسی',
      'lastUpdated': 'آخری اپ ڈیٹ: 17 جون 2025',
      'intro': 'سرویبل میں خوش آمدید۔ ہم آپ کی رازداری کی قدر کرتے ہیں اور آپ کی ذاتی معلومات کے تحفظ کے لیے پرعزم ہیں۔ یہ رازداری کی پالیسی وضاحت کرتی ہے کہ ہم آپ کا ڈیٹا کیسے اکٹھا کرتے، استعمال کرتے، اور حفاظت کرتے ہیں۔',
      'dataCollection': 'ڈیٹا جمع کرنا',
      'dataCollectionDesc': 'ہم آپ کی طرف سے براہ راست فراہم کردہ معلومات، جیسے کہ آپ کا ای میل اور پروفائل کی تفصیلات، اور ہماری خدمات کو بہتر بنانے کے لیے استعمال کے ڈیٹا جمع کرتے ہیں۔',
      'dataUsage': 'ڈیٹا کا استعمال',
      'dataUsageDesc': 'آپ کا ڈیٹا آپ کے تجربے کو ذاتی بنانے، کسٹمر سپورٹ فراہم کرنے، اور ایپ کی فعالیت کو بہتر بنانے کے لیے استعمال کیا جاتا ہے۔',
      'dataSharing': 'ڈیٹا شیئرنگ',
      'dataSharingDesc': 'ہم آپ کا ڈیٹا فروخت نہیں کرتے۔ ہم اپنی خدمات کو بہتر بنانے کے لیے قابل اعتماد شراکت داروں کے ساتھ گمنام ڈیٹا شیئر کر سکتے ہیں۔',
      'yourRights': 'آپ کے حقوق',
      'yourRightsDesc': 'آپ ہم سے رابطہ کرکے اپنے ڈیٹا تک رسائی حاصل کرسکتے ہیں، اسے اپ ڈیٹ کرسکتے ہیں، یا حذف کرسکتے ہیں۔ آپ رازداری کی ترتیبات میں ڈیٹا شیئرنگ سے آپٹ آؤٹ بھی کرسکتے ہیں۔',
      'contactUs': 'ہم سے رابطہ کریں',
      'contactUsDesc': 'اس رازداری کی پالیسی کے بارے میں سوالات کے لیے، support@servable.com پر رابطہ کریں۔',
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
          _translate('privacyPolicy', language),
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
            child: AnimatedOpacity(
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
                        _translate('lastUpdated', language),
                        style: TextStyle(
                          color: textColor.withOpacity(0.7),
                          fontSize: maxWidth * 0.04,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.02),
                      Text(
                        _translate('intro', language),
                        style: TextStyle(
                          color: textColor,
                          fontSize: maxWidth * 0.045,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.03),
                      Text(
                        _translate('dataCollection', language),
                        style: TextStyle(
                          color: textColor,
                          fontSize: maxWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.01),
                      Text(
                        _translate('dataCollectionDesc', language),
                        style: TextStyle(
                          color: textColor,
                          fontSize: maxWidth * 0.045,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.03),
                      Text(
                        _translate('dataUsage', language),
                        style: TextStyle(
                          color: textColor,
                          fontSize: maxWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.01),
                      Text(
                        _translate('dataUsageDesc', language),
                        style: TextStyle(
                          color: textColor,
                          fontSize: maxWidth * 0.045,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.03),
                      Text(
                        _translate('dataSharing', language),
                        style: TextStyle(
                          color: textColor,
                          fontSize: maxWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.01),
                      Text(
                        _translate('dataSharingDesc', language),
                        style: TextStyle(
                          color: textColor,
                          fontSize: maxWidth * 0.045,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.03),
                      Text(
                        _translate('yourRights', language),
                        style: TextStyle(
                          color: textColor,
                          fontSize: maxWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.01),
                      Text(
                        _translate('yourRightsDesc', language),
                        style: TextStyle(
                          color: textColor,
                          fontSize: maxWidth * 0.045,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.03),
                      Text(
                        _translate('contactUs', language),
                        style: TextStyle(
                          color: textColor,
                          fontSize: maxWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.01),
                      Text(
                        _translate('contactUsDesc', language),
                        style: TextStyle(
                          color: textColor,
                          fontSize: maxWidth * 0.045,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}