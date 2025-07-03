import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/theme_provider/themeprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FeedbackScreen extends StatelessWidget {
   FeedbackScreen({super.key});

  // Translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'feedback': 'Feedback',
      'noFeedback': 'No feedback submitted yet.',
      'userId': 'User ID',
      'feedbackText': 'Feedback',
      'timestamp': 'Submitted At',
    },
    'ur': {
      'feedback': 'رائے',
      'noFeedback': 'ابھی تک کوئی رائے جمع نہیں کی گئی۔',
      'userId': 'صارف آئی ڈی',
      'feedbackText': 'رائے',
      'timestamp': 'جمع کیا گیا',
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
          _translate('feedback', language),
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

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('feedback')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF00A86B)));
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: textColor)));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    _translate('noFeedback', language),
                    style: TextStyle(
                      color: textColor,
                      fontSize: maxWidth * 0.05,
                      fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                    ),
                  ),
                );
              }

              final feedbackList = snapshot.data!.docs;

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05, vertical: maxHeight * 0.02),
                itemCount: feedbackList.length,
                itemBuilder: (context, index) {
                  final feedback = feedbackList[index].data() as Map<String, dynamic>;
                  final timestamp = feedback['timestamp'] != null
                      ? DateFormat('dd MMM yyyy, hh:mm a').format((feedback['timestamp'] as Timestamp).toDate())
                      : 'N/A';

                  return AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      margin: EdgeInsets.only(bottom: maxHeight * 0.02),
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
                          // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            Text(
                              '${_translate('userId', language)}: ${feedback['userId'] ?? 'Anonymous'}',
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                              ),
                            ),
                            SizedBox(height: maxHeight * 0.01),
                            Text(
                              '${_translate('feedbackText', language)}: ${feedback['feedback']}',
                              style: TextStyle(
                                color: textColor,
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                              ),
                            ),
                            SizedBox(height: maxHeight * 0.01),
                            Text(
                              '${_translate('timestamp', language)}: $timestamp',
                              style: TextStyle(
                                color: textColor.withOpacity(0.7),
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}