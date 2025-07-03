
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:servable/Screens/worker_detail.dart';
// import 'package:servable/theme_provider/themeprovider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ReportProblemScreen extends StatefulWidget {
//   const ReportProblemScreen({super.key});

//   @override
//   State<ReportProblemScreen> createState() => _ReportProblemScreenState();
// }

// class _ReportProblemScreenState extends State<ReportProblemScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _problemController = TextEditingController();
//   final _contactController = TextEditingController();
//   final namecontroller = TextEditingController();
//   bool _isLoading = false;
//   User? _user;

//   // Translations
//   final Map<String, Map<String, String>> _translations = {
//     'en': {
//       'reportProblem': 'Report a Problem',
//       'description': 'Problem Description',
//       'descriptionHint': 'Describe the issue you encountered',
//       'contact': 'Contact Information (Optional)',
//       'contactHint': 'Enter your email or phone number',
//       'submit': 'Submit Report',
//       'descriptionEmpty': 'Problem description cannot be empty',
//       'reportSubmitted': 'Report submitted successfully',
//       'reportError': 'Failed to submit report: ',
//       'loading': 'Submitting...',
//     },
//     'ur': {
//       'reportProblem': 'مسئلہ رپورٹ کریں',
//       'description': 'مسئلہ کی تفصیل',
//       'descriptionHint': 'آپ کو درپیش مسئلہ بیان کریں',
//       'contact': 'رابطہ کی معلومات (اختیاری)',
//       'contactHint': 'اپنا ای میل یا فون نمبر درج کریں',
//       'submit': 'رپورٹ جمع کروائیں',
//       'descriptionEmpty': 'مسئلہ کی تفصیل خالی نہیں ہو سکتی',
//       'reportSubmitted': 'رپورٹ کامیابی سے جمع ہو گئی',
//       'reportError': 'رپورٹ جمع کرانے میں ناکام: ',
//       'loading': 'جمع کیا جا رہا ہے...',
//     },
//   };

//   String _translate(String key, String language) {
//     return _translations[language]?[key] ?? key;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _user = FirebaseAuth.instance.currentUser;
//     if (_user != null && _user!.email != null && _user?.displayName!=null) {
//       _contactController.text = _user!.email!;
//       namecontroller.text=_user!.displayName!; // Pre-fill email if available
//     }
//   }

//   // Submit problem report
//   Future<void> _submitReport() async {
//     final language = Provider.of<LanguageProvider>(context, listen: false).language;
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);
//       try {
//         // Save report to Firestore
//         await FirebaseFirestore.instance.collection('problem_reports').add({
//           'Name': _user?.displayName ?? 'anonymous',
//           'email': _contactController.text.trim(),
//           'description': _problemController.text.trim(),
//           'timestamp': FieldValue.serverTimestamp(),
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(_translate('reportSubmitted', language)),
//             backgroundColor: const Color(0xFF00A86B),
//             duration: const Duration(seconds: 3),
//           ),
//         );
//         _problemController.clear();
//         _contactController.clear();
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('${_translate('reportError', language)}${e.toString()}'),
//             backgroundColor: Colors.red,
//             duration: const Duration(seconds: 5),
//           ),
//         );
//       } finally {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _problemController.dispose();
//     _contactController.dispose();
//     super.dispose();
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
//           _translate('reportProblem', language),
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

//           return SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05, vertical: maxHeight * 0.03),
//             child: AnimatedOpacity(
//               opacity: 1.0,
//               duration: const Duration(milliseconds: 500),
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       isDark ? Colors.grey[800]! : Colors.white,
//                       isDark ? Colors.grey[850]! : const Color(0xFFF1FCF7),
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 padding: EdgeInsets.all(maxWidth * 0.06),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
//                     children: [
//                       Text(
//                         _translate('description', language),
//                         style: TextStyle(
//                           color: textColor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: maxWidth * 0.05,
//                           fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
//                         ),
//                       ),
//                       SizedBox(height: maxHeight * 0.02),
//                       _buildTextField(
//                         controller: _problemController,
//                         label: _translate('description', language),
//                         hint: _translate('descriptionHint', language),
//                         icon: Icons.error,
//                         textColor: textColor,
//                         isDark: isDark,
//                         isUrdu: isUrdu,
//                         maxLines: 5,
//                         validator: (value) => value == null || value.isEmpty
//                             ? _translate('descriptionEmpty', language)
//                             : null,
//                       ),
//                       SizedBox(height: maxHeight * 0.03),
//                       Text(
//                         _translate('contact', language),
//                         style: TextStyle(
//                           color: textColor,
//                           fontWeight: FontWeight.bold,
//                           fontSize: maxWidth * 0.05,
//                           fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
//                         ),
//                       ),
//                       SizedBox(height: maxHeight * 0.02),
//                       _buildTextField(
//                         controller: _contactController,
//                         label: _translate('contact', language),
//                         hint: _translate('contactHint', language),
//                         icon: Icons.contact_mail,
//                         textColor: textColor,
//                         isDark: isDark,
//                         isUrdu: isUrdu,
//                         maxLines: 1,
//                       ),
//                       SizedBox(height: maxHeight * 0.03),
//                       _isLoading
//                           ? const Center(child: CircularProgressIndicator(color: Color(0xFF00A86B)))
//                           : GestureDetector(
//                               onTap: _submitReport,
//                               child: Container(
//                                 width: double.infinity,
//                                 height: 60,
//                                 decoration: BoxDecoration(
//                                   gradient: const LinearGradient(
//                                     colors: [Color(0xFF00A86B), Colors.teal],
//                                     begin: Alignment.topLeft,
//                                     end: Alignment.bottomRight,
//                                   ),
//                                   borderRadius: BorderRadius.circular(30),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.2),
//                                       blurRadius: 8,
//                                       offset: const Offset(0, 4),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     _translate('submit', language),
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: maxWidth * 0.05,
//                                       fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required String hint,
//     required IconData icon,
//     required Color textColor,
//     required bool isDark,
//     required bool isUrdu,
//     int maxLines = 1,
//     String? Function(String?)? validator,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: isDark ? Colors.grey[850] : Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: TextFormField(
//         controller: controller,
//         style: TextStyle(
//           color: textColor,
//           fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
//         ),
//         validator: validator,
//         textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
//         maxLines: maxLines,
//         decoration: InputDecoration(
//           prefixIcon: Icon(
//             icon,
//             color: controller.text.isNotEmpty ? const Color(0xFF00A86B) : Colors.grey,
//           ),
//           hintText: hint,
//           labelText: label,
//           labelStyle: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: controller.text.isNotEmpty ? const Color(0xFF00A86B) : Colors.grey,
//             fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: BorderSide.none,
//           ),
//           contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//           filled: true,
//           fillColor: Colors.transparent,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/theme_provider/themeprovider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  State<ReportProblemScreen> createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _problemController = TextEditingController();
  final _contactController = TextEditingController();
  final _nameController = TextEditingController(); // New controller for name
  bool _isLoading = false;
  User? _user;

  // Translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'reportProblem': 'Report a Problem',
      'name': 'Name (Optional)', // New translation
      'nameHint': 'Enter your name', // New translation
      'description': 'Problem Description',
      'descriptionHint': 'Describe the issue you encountered',
      'contact': 'Contact Information (Optional)',
      'contactHint': 'Enter your email or phone number',
      'submit': 'Submit Report',
      'descriptionEmpty': 'Problem description cannot be empty',
      'reportSubmitted': 'Report submitted successfully',
      'reportError': 'Failed to submit report: ',
      'loading': 'Submitting...',
    },
    'ur': {
      'reportProblem': 'مسئلہ رپورٹ کریں',
      'name': 'نام (اختیاری)', // New translation
      'nameHint': 'اپنا نام درج کریں', // New translation
      'description': 'مسئلہ کی تفصیل',
      'descriptionHint': 'آپ کو درپیش مسئلہ بیان کریں',
      'contact': 'رابطہ کی معلومات (اختیاری)',
      'contactHint': 'اپنا ای میل یا فون نمبر درج کریں',
      'submit': 'رپورٹ جمع کروائیں',
      'descriptionEmpty': 'مسئلہ کی تفصیل خالی نہیں ہو سکتی',
      'reportSubmitted': 'رپورٹ کامیابی سے جمع ہو گئی',
      'reportError': 'رپورٹ جمع کرانے میں ناکام: ',
      'loading': 'جمع کیا جا رہا ہے...',
    },
  };

  String _translate(String key, String language) {
    return _translations[language]?[key] ?? key;
  }

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      if (_user!.email != null) {
        _contactController.text = _user!.email!; // Pre-fill email
      }
      if (_user!.displayName != null) {
        _nameController.text = _user!.displayName!; // Pre-fill name
      }
    }
  }

  // Submit problem report
  Future<void> _submitReport() async {
    final language = Provider.of<LanguageProvider>(context, listen: false).language;
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        // Save report to Firestore
        await FirebaseFirestore.instance.collection('problem_reports').add({
          'userId': _user?.uid ?? 'anonymous',
          'name': _nameController.text.trim(), // Add name to Firestore
          'email': _contactController.text.trim(),
          'description': _problemController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_translate('reportSubmitted', language)),
            backgroundColor: const Color(0xFF00A86B),
            duration: const Duration(seconds: 3),
          ),
        );
        _problemController.clear();
        _contactController.clear();
        _nameController.clear(); // Clear name field
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_translate('reportError', language)}${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _problemController.dispose();
    _contactController.dispose();
    _nameController.dispose(); // Dispose name controller
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
          _translate('reportProblem', language),
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
            padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05, vertical: maxHeight * 0.03),
            child: AnimatedOpacity(
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
                padding: EdgeInsets.all(maxWidth * 0.06),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                    children: [
                      Text(
                        _translate('name', language),
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: maxWidth * 0.05,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.02),
                      _buildTextField(
                        controller: _nameController,
                        label: _translate('name', language),
                        hint: _translate('nameHint', language),
                        icon: Icons.person,
                        textColor: textColor,
                        isDark: isDark,
                        isUrdu: isUrdu,
                        maxLines: 1,
                      ),
                      SizedBox(height: maxHeight * 0.03),
                      Text(
                        _translate('description', language),
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: maxWidth * 0.05,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.02),
                      _buildTextField(
                        controller: _problemController,
                        label: _translate('description', language),
                        hint: _translate('descriptionHint', language),
                        icon: Icons.error,
                        textColor: textColor,
                        isDark: isDark,
                        isUrdu: isUrdu,
                        maxLines: 5,
                        validator: (value) => value == null || value.isEmpty
                            ? _translate('descriptionEmpty', language)
                            : null,
                      ),
                      SizedBox(height: maxHeight * 0.03),
                      Text(
                        _translate('contact', language),
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: maxWidth * 0.05,
                          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                        ),
                      ),
                      SizedBox(height: maxHeight * 0.02),
                      _buildTextField(
                        controller: _contactController,
                        label: _translate('contact', language),
                        hint: _translate('contactHint', language),
                        icon: Icons.contact_mail,
                        textColor: textColor,
                        isDark: isDark,
                        isUrdu: isUrdu,
                        maxLines: 1,
                      ),
                      SizedBox(height: maxHeight * 0.03),
                      _isLoading
                          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00A86B)))
                          : GestureDetector(
                              onTap: _submitReport,
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
                                    _translate('submit', language),
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
              ),
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
    int maxLines = 1,
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
        maxLines: maxLines,
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