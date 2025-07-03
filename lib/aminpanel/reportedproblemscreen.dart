// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:servable/Screens/worker_detail.dart';
// import 'package:servable/theme_provider/themeprovider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class ReportedProblemsScreen extends StatelessWidget {
//    ReportedProblemsScreen({super.key});
 
//   // Translations
//   final Map<String, Map<String, String>> _translations = {
//     'en': {
//       'reportedProblems': 'Reported Problems',
//       'noProblems': 'No problems reported yet.',
//       'userId': 'User ID',
//       'email': 'Email',
//       'description': 'Description',
//       'timestamp': 'Reported At',
//     },
//     'ur': {
//       'reportedProblems': 'رپورٹ کردہ مسائل',
//       'noProblems': 'ابھی تک کوئی مسائل رپورٹ نہیں ہوئے۔',
//       'userId': 'صارف آئی ڈی',
//       'email': 'ای میل',
//       'description': 'تفصیل',
//       'timestamp': 'رپورٹ کیا گیا',
//     },
//   };

//   String _translate(String key, String language) {
//     return _translations[language]?[key] ?? key;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<Themeprovider>(context);
//     final languageProvider = Provider.of<LanguageProvider>(context);
//     final isDark = themeProvider.themeMode == ThemeMode.dark;
//     final isUrdu = languageProvider.isUrdu;
//     final language = languageProvider.language;
//     final bgColor = isDark ? Colors.black : const Color(0xFFF1FCF7);
//     final textColor = isDark ? Colors.white : Colors.black87;

//     return Scaffold(
//       backgroundColor: bgColor,
//       appBar: AppBar(
//         title: Text(
//           _translate('reportedProblems', language),
//           style: TextStyle(
//             color: textColor,
//             fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: bgColor,
//         elevation: 0,
//         iconTheme: const IconThemeData(
//           color: Color(0xFF00A86B),
//           size: 28,
//         ),
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           final maxWidth = constraints.maxWidth;
//           final maxHeight = constraints.maxHeight;

//           return StreamBuilder<QuerySnapshot>(
//             stream: FirebaseFirestore.instance
//                 .collection('problem_reports')
//                 .orderBy('timestamp', descending: true)
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator(color: Color(0xFF00A86B)));
//               }
//               if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: textColor)));
//               }
//               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                 return Center(
//                   child: Text(
//                     _translate('noProblems', language),
//                     style: TextStyle(
//                       color: textColor,
//                       fontSize: maxWidth * 0.05,
//                       fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
//                     ),
//                   ),
//                 );
//               }

//               final reports = snapshot.data!.docs;

//               return ListView.builder(
//                 padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05, vertical: maxHeight * 0.02),
//                 itemCount: reports.length,
//                 itemBuilder: (context, index) {
//                   final report = reports[index].data() as Map<String, dynamic>;
//                   final timestamp = report['timestamp'] != null
//                       ? DateFormat('dd MMM yyyy, hh:mm a').format((report['timestamp'] as Timestamp).toDate())
//                       : 'N/A';

//                   return AnimatedOpacity(
//                     opacity: 1.0,
//                     duration: const Duration(milliseconds: 500),
//                     child: Card(
//                       elevation: 4,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//                       margin: EdgeInsets.only(bottom: maxHeight * 0.02),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               isDark ? Colors.grey[800]! : Colors.white,
//                               isDark ? Colors.grey[850]! : const Color(0xFFF1FCF7),
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         padding: EdgeInsets.all(maxWidth * 0.05),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
//                           children: [
//                             Text(
//                               '${_translate('Name', language)}: ${report['Name'] ?? 'Anonymous'}',
//                               style: TextStyle(
//                                 color: textColor,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
//                               ),
//                             ),
//                             SizedBox(height: maxHeight * 0.01),
//                             Text(
//                               '${_translate('email', language)}: ${report['email'] ?? 'N/A'}',
//                               style: TextStyle(
//                                 color: textColor.withOpacity(0.7),
//                                 fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
//                               ),
//                             ),
//                             SizedBox(height: maxHeight * 0.01),
//                             Text(
//                               '${_translate('description', language)}: ${report['description']}',
//                               style: TextStyle(
//                                 color: textColor,
//                                 fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
//                               ),
//                             ),
//                             SizedBox(height: maxHeight * 0.01),
//                             Text(
//                               '${_translate('timestamp', language)}: $timestamp',
//                               style: TextStyle(
//                                 color: textColor.withOpacity(0.7),
//                                 fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/theme_provider/themeprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportedProblemsScreen extends StatelessWidget {
   ReportedProblemsScreen({super.key});

  // Translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'reportedProblems': 'Reported Problems',
      'noProblems': 'No problems reported yet.',
      'name': 'Name',
      'email': 'Email',
      'description': 'Description',
      'timestamp': 'Reported At',
      'emailError': 'Failed to open email client', // New translation
    },
    'ur': {
      'reportedProblems': 'رپورٹ کردہ مسائل',
      'noProblems': 'ابھی تک کوئی مسائل رپورٹ نہیں ہوئے۔',
      'name': 'نام',
      'email': 'ای میل',
      'description': 'تفصیل',
      'timestamp': 'رپورٹ کیا گیا',
      'emailError': 'ای میل کلائنٹ کھولنے میں ناکام', // New translation
    },
  };

  String _translate(String key, String language) {
    return _translations[language]?[key] ?? key;
  }

  // Launch email client
  Future<void> _launchEmail(String email, BuildContext context, String language) async {
    if (email.isEmpty || email == 'N/A') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_translate('emailError', language)),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_translate('emailError', language)),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
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
          _translate('reportedProblems', language),
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
                .collection('problem_reports')
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
                    _translate('noProblems', language),
                    style: TextStyle(
                      color: textColor,
                      fontSize: maxWidth * 0.05,
                      fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                    ),
                    // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                  ),
                );
              }

              final reports = snapshot.data!.docs;

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05, vertical: maxHeight * 0.02),
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final report = reports[index].data() as Map<String, dynamic>;
                  final timestamp = report['timestamp'] != null
                      ? DateFormat('dd MMM yyyy, hh:mm a').format((report['timestamp'] as Timestamp).toDate())
                      : 'N/A';
                  final email = report['email'] ?? 'N/A';

                  return AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 500),
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
                      margin: EdgeInsets.only(bottom: maxHeight * 0.02),
                      padding: EdgeInsets.all(maxWidth * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        children: [
                          Text(
                            '${_translate('name', language)}: ${report['name'] ?? 'Anonymous'}',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                            ),
                          ),
                          SizedBox(height: maxHeight * 0.01),
                          GestureDetector(
                            onTap: () => _launchEmail(email, context, language),
                            child: Text(
                              '${_translate('email', language)}: $email',
                              style: TextStyle(
                                color: email != 'N/A' && email.isNotEmpty
                                    ? const Color(0xFF00A86B)
                                    : textColor.withOpacity(0.7),
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                decoration: email != 'N/A' && email.isNotEmpty
                                    ? TextDecoration.underline
                                    : null,
                              ),
                            ),
                          ),
                          SizedBox(height: maxHeight * 0.01),
                          Text(
                            '${_translate('description', language)}: ${report['description']}',
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