// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class SecurityScreen extends StatefulWidget {
//   @override
//   _SecurityScreenState createState() => _SecurityScreenState();
// }

// class _SecurityScreenState extends State<SecurityScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _newPasswordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _isLoading = false;
//   User? _user;

//   @override
//   void initState() {
//     super.initState();
//     _user = FirebaseAuth.instance.currentUser;
//   }

//   Future<void> _changePassword() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);
//       try {
//         await _user!.updatePassword(_newPasswordController.text);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Password changed successfully.")),
//         );
//         _newPasswordController.clear();
//         _confirmPasswordController.clear();
//       } on FirebaseAuthException catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error: ${e.message}")),
//         );
//       } finally {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   Future<void> _sendVerificationEmail() async {
//     try {
//       await _user!.sendEmailVerification();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Verification email sent.")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to send email verification.")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isVerified = _user?.emailVerified ?? false;

//     return Scaffold(
//       appBar: AppBar(title: Text("Security")),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // 🔐 Email Verification Status
//             Card(
//               elevation: 3,
//               child: ListTile(
//                 leading: Icon(Icons.email),
//                 title: Text(_user?.email ?? 'No Email'),
//                 subtitle: Text(isVerified ? 'Verified' : 'Not Verified'),
//                 trailing: isVerified
//                     ? Icon(Icons.verified, color: Colors.green)
//                     : TextButton(
//                         child: Text("Verify"),
//                         onPressed: _sendVerificationEmail,
//                       ),
//               ),
//             ),
//             SizedBox(height: 20),

//             // 🔒 Change Password Form
//             Text("Change Password", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 10),
//             Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: _newPasswordController,
//                     obscureText: true,
//                     decoration: InputDecoration(labelText: "New Password"),
//                     validator: (value) =>
//                         value == null || value.length < 6 ? "Minimum 6 characters" : null,
//                   ),
//                   SizedBox(height: 12),
//                   TextFormField(
//                     controller: _confirmPasswordController,
//                     obscureText: true,
//                     decoration: InputDecoration(labelText: "Confirm Password"),
//                     validator: (value) =>
//                         value != _newPasswordController.text ? "Passwords do not match" : null,
//                   ),
//                   SizedBox(height: 20),
//                   _isLoading
//                       ? CircularProgressIndicator()
//                       : ElevatedButton(
//                           onPressed: _changePassword,
//                           child: Text("Change Password"),
//                         ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 30),

//             // 🔐 Placeholder for 2FA
//             Card(
//               elevation: 3,
//               child: ListTile(
//                 leading: Icon(Icons.shield),
//                 title: Text("Two-Factor Authentication"),
//                 subtitle: Text("Coming soon"),
//                 trailing: Icon(Icons.lock),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/theme_provider/themeprovider.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  User? _user;

  // Translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'security': 'Security',
      'email': 'Email',
      'verified': 'Verified',
      'notVerified': 'Not Verified',
      'verify': 'Verify',
      'changePassword': 'Change Password',
      'newPassword': 'New Password',
      'confirmPassword': 'Confirm Password',
      'passwordMinLength': 'Minimum 6 characters',
      'passwordsNoMatch': 'Passwords do not match',
      'twoFactorAuth': 'Two-Factor Authentication',
      'comingSoon': 'Coming soon',
      'passwordChanged': 'Password changed successfully',
      'passwordChangeError': 'Error: ',
      'verificationEmailSent': 'Verification email sent',
      'verificationEmailFailed': 'Failed to send email verification',
    },
    'ur': {
      'security': 'سیکیورٹی',
      'email': 'ای میل',
      'verified': 'تصدیق شدہ',
      'notVerified': 'غیر تصدیق شدہ',
      'verify': 'تصدیق کریں',
      'changePassword': 'پاس ورڈ تبدیل کریں',
      'newPassword': 'نیا پاس ورڈ',
      'confirmPassword': 'پاس ورڈ کی تصدیق کریں',
      'passwordMinLength': 'کم از کم 6 حروف',
      'passwordsNoMatch': 'پاس ورڈز مماثل نہیں ہیں',
      'twoFactorAuth': 'دو عنصری تصدیق',
      'comingSoon': 'جلد آرہا ہے',
      'passwordChanged': 'پاس ورڈ کامیابی سے تبدیل ہو گیا',
      'passwordChangeError': 'خرابی: ',
      'verificationEmailSent': 'تصدیقی ای میل بھیج دی گئی',
      'verificationEmailFailed': 'ای میل تصدیق بھیجنے میں ناکام',
    },
  };

  String _translate(String key, String language) {
    return _translations[language]?[key] ?? key;
  }

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> _changePassword() async {
    final language = Provider.of<LanguageProvider>(context, listen: false).language;
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _user!.updatePassword(_newPasswordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_translate('passwordChanged', language)),
            backgroundColor: const Color(0xFF00A86B),
            duration: const Duration(seconds: 3),
          ),
        );
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_translate('passwordChangeError', language)}${e.message}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _sendVerificationEmail() async {
    final language = Provider.of<LanguageProvider>(context, listen: false).language;
    try {
      await _user!.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_translate('verificationEmailSent', language)),
          backgroundColor: const Color(0xFF00A86B),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_translate('verificationEmailFailed', language)),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
    final isVerified = _user?.emailVerified ?? false;

    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        
        appBar: AppBar(
          leading: GestureDetector(
            onTap: (){
             Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color: Colors.white,)),
          automaticallyImplyLeading: false,
           flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF00A86B), Colors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            
          centerTitle: true,
          title: Text(
            _translate('security', language),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
            ),
          ),
          
          backgroundColor: bgColor,
          elevation: 0,
          iconTheme: IconThemeData(color: textColor),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final maxHeight = constraints.maxHeight;
      
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05, vertical: 16),
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                  children: [
                    // Email Verification Status
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
                            leading: Icon(Icons.email, color: const Color(0xFF00A86B)),
                            title: Text(
                              _user?.email ?? _translate('email', language),
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                              ),
                            ),
                            subtitle: Text(
                              isVerified
                                  ? _translate('verified', language)
                                  : _translate('notVerified', language),
                              style: TextStyle(
                                color: isVerified ? const Color(0xFF00A86B) : Colors.red,
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                              ),
                            ),
                            trailing: isVerified
                                ? const Icon(Icons.verified, color: Color(0xFF00A86B))
                                : TextButton(
                                    onPressed: _sendVerificationEmail,
                                    child: Text(
                                      _translate('verify', language),
                                      style: const TextStyle(
                                        color: Color(0xFF00A86B),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: maxHeight * 0.03),
                
                    // Change Password Form
                    Text(
                      _translate('changePassword', language),
                      style: TextStyle(
                        fontSize: maxWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                      ),
                    ),
                    SizedBox(height: maxHeight * 0.02),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _newPasswordController,
                            label: _translate('newPassword', language),
                            hint: _translate('newPassword', language),
                            icon: Icons.lock,
                            textColor: textColor,
                            isDark: isDark,
                            isUrdu: isUrdu,
                            obscureText: true,
                            validator: (value) =>
                                value == null || value.length < 6 ? _translate('passwordMinLength', language) : null,
                          ),
                          SizedBox(height: maxHeight * 0.02),
                          _buildTextField(
                            controller: _confirmPasswordController,
                            label: _translate('confirmPassword', language),
                            hint: _translate('confirmPassword', language),
                            icon: Icons.lock,
                            textColor: textColor,
                            isDark: isDark,
                            isUrdu: isUrdu,
                            obscureText: true,
                            validator: (value) => value != _newPasswordController.text
                                ? _translate('passwordsNoMatch', language)
                                : null,
                          ),
                          SizedBox(height: maxHeight * 0.03),
                          _isLoading
                              ? const CircularProgressIndicator(color: Color(0xFF00A86B))
                              : GestureDetector(
                                  onTap: _changePassword,
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
                                        _translate('changePassword', language),
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
                    SizedBox(height: maxHeight * 0.04),
                
                    // Two-Factor Authentication Placeholder
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
                            leading: const Icon(Icons.shield, color: Color(0xFF00A86B)),
                            title: Text(
                              _translate('twoFactorAuth', language),
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                              ),
                            ),
                            subtitle: Text(
                              _translate('comingSoon', language),
                              style: TextStyle(
                                color: textColor.withOpacity(0.7),
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                              ),
                            ),
                            trailing: const Icon(Icons.lock, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
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
    bool obscureText = false,
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
        obscureText: obscureText,
        style: TextStyle(
          color: textColor,
          fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
        ),
        validator: validator,
        textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
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