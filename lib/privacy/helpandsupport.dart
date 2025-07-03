import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/theme_provider/themeprovider.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _feedbackController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<bool> _isExpanded = List.generate(3, (_) => false); // For FAQ expansion

  // Translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'helpSupport': 'Help and Support',
      'faqs': 'Frequently Asked Questions',
      'faq1Q': 'How do I reset my password?',
      'faq1A': 'Go to the login screen, tap "Forgot Password?", and enter your email to receive a reset link.',
      'faq2Q': 'How can I change my language preference?',
      'faq2A': 'Navigate to the settings screen and toggle between English and Urdu using the language switch.',
      'faq3Q': 'How do I contact support?',
      'faq3A': 'Use the "Contact Support" button below to send us an email, or submit feedback through the form.',
      'contactSupport': 'Contact Support',
      'contactSupportDesc': 'Send us an email for assistance',
      'feedback': 'Submit Feedback',
      'feedbackDesc': 'Share your feedback or report issues',
      'feedbackHint': 'Enter your feedback here',
      'feedbackEmpty': 'Feedback cannot be empty',
      'feedbackSubmitted': 'Feedback submitted successfully',
      'feedbackError': 'Failed to submit feedback',
      'emailError': 'Failed to open email client',
    },
    'ur': {
      'helpSupport': 'مدد اور سپورٹ',
      'faqs': 'اکثر پوچھے جانے والے سوالات',
      'faq1Q': 'میں اپنا پاس ورڈ کیسے ری سیٹ کروں؟',
      'faq1A': 'لاگ ان اسکرین پر جائیں، "پاس ورڈ بھول گئے؟" پر ٹیپ کریں، اور ری سیٹ لنک وصول کرنے کے لیے اپنا ای میل درج کریں۔',
      'faq2Q': 'میں اپنی زبان کی ترجیح کیسے تبدیل کروں؟',
      'faq2A': 'ترتیبات اسکرین پر جائیں اور زبان کے سوئچ کا استعمال کرتے ہوئے انگریزی اور اردو کے درمیان ٹوگل کریں۔',
      'faq3Q': 'میں سپورٹ سے رابطہ کیسے کروں؟',
      'faq3A': 'ہم سے ای میل بھیجنے کے لیے نیچے "رابطہ کریں" بٹن کا استعمال کریں، یا فارم کے ذریعے رائے جمع کروائیں۔',
      'contactSupport': 'رابطہ کریں',
      'contactSupportDesc': 'مدد کے لیے ہمیں ای میل بھیجیں',
      'feedback': 'رائے جمع کروائیں',
      'feedbackDesc': 'اپنی رائے شیئر کریں یا مسائل کی اطلاع دیں',
      'feedbackHint': 'یہاں اپنی رائے درج کریں',
      'feedbackEmpty': 'رائے خالی نہیں ہو سکتی',
      'feedbackSubmitted': 'رائے کامیابی سے جمع ہو گئی',
      'feedbackError': 'رائے جمع کرانے میں ناکام',
      'emailError': 'ای میل کلائنٹ کھولنے میں ناکام',
    },
  };

  String _translate(String key, String language) {
    return _translations[language]?[key] ?? key;
  }

  // Launch email client for support
  Future<void> _launchEmailSupport() async {
    final language = Provider.of<LanguageProvider>(context, listen: false).language;
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@servable.com', // Replace with your actual support email
      queryParameters: {'subject': 'Support Request'},
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_translate('emailError', language)),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  // Submit feedback (placeholder logic)
  void _submitFeedback() {
    final language = Provider.of<LanguageProvider>(context, listen: false).language;
    if (_formKey.currentState!.validate()) {
      // TODO: Implement actual feedback submission (e.g., to Firebase Firestore)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_translate('feedbackSubmitted', language)),
          backgroundColor: const Color(0xFF00A86B),
          duration: const Duration(seconds: 3),
        ),
      );
      _feedbackController.clear();
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
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

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          _translate('helpSupport', language),
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
                // FAQs Section
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
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              _translate('faqs', language),
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: maxWidth * 0.05,
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                              ),
                            ),
                          ),
                          ExpansionTile(
                            leading: const Icon(Icons.question_answer, color: Color(0xFF00A86B)),
                            title: Text(
                              _translate('faq1Q', language),
                              style: TextStyle(
                                color: textColor,
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                              ),
                            ),
                            onExpansionChanged: (expanded) => setState(() => _isExpanded[0] = expanded),
                            trailing: Icon(
                              _isExpanded[0] ? Icons.expand_less : Icons.expand_more,
                              color: const Color(0xFF00A86B),
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05, vertical: 8),
                                child: Text(
                                  _translate('faq1A', language),
                                  style: TextStyle(
                                    color: textColor.withOpacity(0.7),
                                    fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                  ),
                                  textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                ),
                              ),
                            ],
                          ),
                          ExpansionTile(
                            leading: const Icon(Icons.question_answer, color: Color(0xFF00A86B)),
                            title: Text(
                              _translate('faq2Q', language),
                              style: TextStyle(
                                color: textColor,
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                              ),
                            ),
                            onExpansionChanged: (expanded) => setState(() => _isExpanded[1] = expanded),
                            trailing: Icon(
                              _isExpanded[1] ? Icons.expand_less : Icons.expand_more,
                              color: const Color(0xFF00A86B),
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05, vertical: 8),
                                child: Text(
                                  _translate('faq2A', language),
                                  style: TextStyle(
                                    color: textColor.withOpacity(0.7),
                                    fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                  ),
                                  textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                ),
                              ),
                            ],
                          ),
                          ExpansionTile(
                            leading: const Icon(Icons.question_answer, color: Color(0xFF00A86B)),
                            title: Text(
                              _translate('faq3Q', language),
                              style: TextStyle(
                                color: textColor,
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                              ),
                            ),
                            onExpansionChanged: (expanded) => setState(() => _isExpanded[2] = expanded),
                            trailing: Icon(
                              _isExpanded[2] ? Icons.expand_less : Icons.expand_more,
                              color: const Color(0xFF00A86B),
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05, vertical: 8),
                                child: Text(
                                  _translate('faq3A', language),
                                  style: TextStyle(
                                    color: textColor.withOpacity(0.7),
                                    fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                  ),
                                  textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
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

                // Contact Support
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
                        leading: const Icon(Icons.email, color: Color(0xFF00A86B)),
                        title: Text(
                          _translate('contactSupport', language),
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                          ),
                        ),
                        subtitle: Text(
                          _translate('contactSupportDesc', language),
                          style: TextStyle(
                            color: textColor.withOpacity(0.7),
                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward, color: Color(0xFF00A86B)),
                        onTap: _launchEmailSupport,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: maxHeight * 0.03),

                // Feedback Form
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
                        children: [
                          Text(
                            _translate('feedback', language),
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: maxWidth * 0.05,
                              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                            ),
                          ),
                          SizedBox(height: maxHeight * 0.02),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildTextField(
                                  controller: _feedbackController,
                                  label: _translate('feedback', language),
                                  hint: _translate('feedbackHint', language),
                                  icon: Icons.feedback,
                                  textColor: textColor,
                                  isDark: isDark,
                                  isUrdu: isUrdu,
                                  validator: (value) => value == null || value.isEmpty
                                      ? _translate('feedbackEmpty', language)
                                      : null,
                                ),
                                SizedBox(height: maxHeight * 0.03),
                                GestureDetector(
                                  onTap: _submitFeedback,
                                  child: Container(
                                    width: double.infinity,
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
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        _translate('feedback', language),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: maxWidth * 0.05,
                                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color textColor,
    required bool isDark,
    required bool isUrdu,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          color: textColor,
          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
        ),
        validator: validator,
        textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
        maxLines: 4,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: controller.text.isNotEmpty ? const Color(0xFF00A86B) : Colors.grey,
          ),
          hintText: hint,
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: controller.text.isNotEmpty ? const Color(0xFF00A86B) : Colors.grey,
            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }
}