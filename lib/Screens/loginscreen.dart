
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:servable/Screens/choice.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/customer_view/customer_profilescreen.dart';
import 'package:servable/customer_view/registration.dart';
import 'package:servable/customer_view/homescreen.dart';
import 'package:servable/splashsreens/splashscreen2.dart';
import 'package:provider/provider.dart';
import 'package:servable/theme_provider/themeprovider.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final _formkey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  // Embedded translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'welcomeBack': 'Welcome Back',
      'signInToContinue': 'Sign in to continue',
      'emailLabel': 'Email',
      'emailHint': 'Enter Email',
      'emailEmptyError': "Email can't be empty",
      'emailInvalidError': 'Enter a valid email',
      'passwordLabel': 'Password',
      'passwordHint': 'Enter Password',
      'passwordEmptyError': "Password can't be empty",
      'passwordLengthError': 'Password must be at least 6 characters',
      'forgotPassword': 'Forgot Password?',
      'loginButton': 'Login',
      'noAccount': "Don't have an account? ",
      'signUp': 'Sign Up',
      'continueWithGoogle': 'Continue with Google',
      'loginSuccess': 'Login Successfully',
      'loginFailed': 'Login Failed: ',
      'googleSignInSuccess': 'Signed in as ',
      'googleSignInError': 'Error signing in: ',
      'passwordResetSuccess': 'Password reset email sent successfully',
      'passwordResetFailed': 'Failed to send password reset email: ',
    },
    'ur': {
      'welcomeBack': 'خوش آمدید',
      'signInToContinue': 'جاری رکھنے کے لیے سائن ان کریں',
      'emailLabel': 'ای میل',
      'emailHint': 'ای میل درج کریں',
      'emailEmptyError': 'ای میل خالی نہیں ہو سکتا',
      'emailInvalidError': 'ایک درست ای میل درج کریں',
      'passwordLabel': 'پاس ورڈ',
      'passwordHint': 'پاس ورڈ درج کریں',
      'passwordEmptyError': 'پاس ورڈ خالی نہیں ہو سکتا',
      'passwordLengthError': 'پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے',
      'forgotPassword': 'پاس ورڈ بھول گئے؟',
      'loginButton': 'لاگ ان',
      'noAccount': 'کیا آپ کا اکاؤنٹ نہیں ہے؟ ',
      'signUp': 'سائن اپ',
      'continueWithGoogle': 'گوگل کے ساتھ جاری رکھیں',
      'loginSuccess': 'لاگ ان کامیاب',
      'loginFailed': 'لاگ ان ناکام: ',
      'googleSignInSuccess': 'کے طور پر سائن ان کیا ',
      'googleSignInError': 'سائن ان میں خرابی: ',
      'passwordResetSuccess': 'پاس ورڈ ری سیٹ ای میل کامیابی سے بھیج دی گئی',
      'passwordResetFailed': 'پاس ورڈ ری سیٹ ای میل بھیجنے میں ناکامی: ',
    },
  };

  String _translate(String key, String language) {
    return _translations[language]?[key] ?? key;
  }

  Future<UserCredential> SignInwithgoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credentials);
  }

  void login() {
    final language = Provider.of<LanguageProvider>(context, listen: false).language;
    auth
        .signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        )
        .then((UserCredential credential) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Homescreen()),
        (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_translate('loginSuccess', language)),
          backgroundColor: Color(0xFF00A86B),
          duration: Duration(seconds: 3),
        ),
      );
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_translate('loginFailed', language)}$e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 10),
        ),
      );
    });
  }

  void resetPassword() {
    final language = Provider.of<LanguageProvider>(context, listen: false).language;
    final email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_translate('emailEmptyError', language)),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_translate('emailInvalidError', language)),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    print("Sending password reset email to: $email"); // Debug log
    auth.sendPasswordResetEmail(email: email).then((_) {
      print("Password reset email sent successfully to: $email"); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${_translate('passwordResetSuccess', language)}. Check your spam/junk folder."), // Enhanced feedback
          backgroundColor: Color(0xFF00A86B),
          duration: Duration(seconds: 3),
        ),
      );
    }).catchError((e) {
      print("Error sending password reset email: ${e.code}, ${e.message}"); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_translate('passwordResetFailed', language)}${e.message}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 10),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() => setState(() {}));
    passwordFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
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

    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          SystemNavigator.pop(animated: false);
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: bgColor,
          body: LayoutBuilder(
            builder: (context, constraints) {
              double maxWidth = constraints.maxWidth;
              double maxHeight = constraints.maxHeight;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.05),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        SizedBox(height: maxHeight * 0.08),
                        // Logo Section
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: Duration(milliseconds: 500),
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
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
                        SizedBox(height: maxHeight * 0.06),
                        // Welcome Text
                        Text(
                          _translate('welcomeBack', language),
                          style: TextStyle(
                            fontSize: maxWidth * 0.08,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                          ),
                          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        ),
                        SizedBox(height: maxHeight * 0.02),
                        Text(
                          _translate('signInToContinue', language),
                          style: TextStyle(
                            fontSize: maxWidth * 0.04,
                            color: textColor.withOpacity(0.7),
                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                          ),
                          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        ),
                        SizedBox(height: maxHeight * 0.04),
                        // Email Input Field
                        _buildTextField(
                          controller: emailController,
                          focusNode: emailFocusNode,
                          label: _translate('emailLabel', language),
                          hint: _translate('emailHint', language),
                          icon: Icons.email,
                          textColor: textColor,
                          isDark: isDark,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return _translate('emailEmptyError', language);
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return _translate('emailInvalidError', language);
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: maxHeight * 0.02),
                        // Password Input Field
                        _buildTextField(
                          controller: passwordController,
                          focusNode: passwordFocusNode,
                          label: _translate('passwordLabel', language),
                          hint: _translate('passwordHint', language),
                          icon: Icons.lock_rounded,
                          textColor: textColor,
                          isDark: isDark,
                          obscureText: !isPasswordVisible,
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() => isPasswordVisible = !isPasswordVisible),
                            child: Icon(
                              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: passwordFocusNode.hasFocus ? Color(0xFF00A86B) : Colors.grey,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return _translate('passwordEmptyError', language);
                            }
                            if (value.length < 6) {
                              return _translate('passwordLengthError', language);
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: maxHeight * 0.01),
                        // Forgot Password Link
                        Align(
                          alignment: isUrdu ? Alignment.centerRight : Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: resetPassword,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 200),
                              child: Text(
                                _translate('forgotPassword', language),
                                style: TextStyle(
                                  fontSize: maxWidth * 0.04,
                                  color: Color(0xFF00A86B),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                ),
                                textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: maxHeight * 0.03),
                        // Login Button
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: Duration(milliseconds: 500),
                          child: GestureDetector(
                            onTap: () {
                              if (_formkey.currentState!.validate()) {
                                login();
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
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
                                  _translate('loginButton', language),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: maxWidth * 0.05,
                                    fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                  ),
                                  textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: maxHeight * 0.03),
                        // Sign Up Redirect
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            Text(
                              _translate('noAccount', language),
                              style: TextStyle(
                                fontSize: maxWidth * 0.04,
                                color: textColor,
                                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                              ),
                              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ChoiceScreen()),
                                );
                              },
                              child: Text(
                                _translate('signUp', language),
                                style: TextStyle(
                                  fontSize: maxWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00A86B),
                                  fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                ),
                                textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: maxHeight * 0.04),
                        // Google Login Button
                        AnimatedOpacity(
                          opacity: 1.0,
                          duration: Duration(milliseconds: 500),
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                final UserCredential userCredential = await SignInwithgoogle();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => Homescreen()),
                                  (route) => false,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${_translate('googleSignInSuccess', language)}${userCredential.user?.displayName ?? 'User'}',
                                      textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                    ),
                                    backgroundColor: Color(0xFF00A86B),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${_translate('googleSignInError', language)}$e',
                                      textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                    ),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 10),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey[850] : Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                children: [
                                  CircleAvatar(
                                    radius: maxWidth * 0.04,
                                    backgroundColor: Colors.transparent,
                                    child: Image.asset('assets/firebase/google.png'),
                                  ),
                                  SizedBox(width: maxWidth * 0.03),
                                  Text(
                                    _translate('continueWithGoogle', language),
                                    style: TextStyle(
                                      fontSize: maxWidth * 0.045,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                      fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                    ),
                                    textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: maxHeight * 0.04),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    required Color textColor,
    required bool isDark,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    final language = Provider.of<LanguageProvider>(context).isUrdu ? 'ur' : 'en';
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        style: TextStyle(
          color: textColor,
          fontFamily: language == 'ur' ? 'NotoNastaliqUrdu' : null,
        ),
        validator: validator,
        textDirection: language == 'ur' ? TextDirection.rtl : TextDirection.ltr,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: focusNode.hasFocus ? Color(0xFF00A86B) : Colors.grey,
          ),
          suffixIcon: suffixIcon,
          hintText: hint,
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: focusNode.hasFocus ? Color(0xFF00A86B) : Colors.grey,
            fontFamily: language == 'ur' ? 'NotoNastaliqUrdu' : null,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: Colors.transparent,
        ),
      ),
    );
  }
}