
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/customer_view/homescreen.dart';
import 'package:servable/theme_provider/themeprovider.dart';



class CustomerImageProvider with ChangeNotifier {
  File? _image;
  final ImagePicker _imagePicker = ImagePicker();
  bool isPasswordVisible = false;

  File? get image => _image;

  Future<void> pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        notifyListeners();
        print("Image picked: ${pickedFile.path}");
      }
    } catch (e) {
      print("Image pick error: $e");
    }
  }

  void toggleVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }
}

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  bool _isLoading = false;

  // Embedded translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'customerRegistration': 'Customer Registration',
      'createAccount': 'Create Your Account',
      'fillDetails': 'Fill in your details to register',
      'fullNameHint': 'Full Name',
      'emailHint': 'Email',
      'passwordHint': 'Password',
      'phoneNumberHint': 'Phone Number',
      'cityHint': 'City',
      'continueButton': 'Continue',
      'successfullyRegistered': 'User has been successfully registered',
      'registrationFailed': 'Registration Failed: {error}',
      'fullNameError': 'Full Name cannot be empty',
      'emailEmptyError': 'Email cannot be empty',
      'emailInvalidError': 'Enter a valid email',
      'passwordEmptyError': 'Password cannot be empty',
      'passwordLengthError': 'Password must be at least 6 characters',
      'phoneEmptyError': 'Phone Number cannot be empty',
      'phoneInvalidError': 'Enter a valid phone number',
      'cityError': 'City cannot be empty',
    },
    'ur': {
      'customerRegistration': 'صارف رجسٹریشن',
      'createAccount': 'اپنا اکاؤنٹ بنائیں',
      'fillDetails': 'رجسٹریشن کے لیے اپنی تفصیلات پُر کریں',
      'fullNameHint': 'مکمل نام',
      'emailHint': 'ای میل',
      'passwordHint': 'پاس ورڈ',
      'phoneNumberHint': 'فون نمبر',
      'cityHint': 'شہر',
      'continueButton': 'جاری رکھیں',
      'successfullyRegistered': 'صارف کامیابی سے رجسٹرڈ ہو گیا',
      'registrationFailed': 'رجسٹریشن ناکام: {error}',
      'fullNameError': 'مکمل نام خالی نہیں ہو سکتا',
      'emailEmptyError': 'ای میل خالی نہیں ہو سکتا',
      'emailInvalidError': 'ایک درست ای میل درج کریں',
      'passwordEmptyError': 'پاس ورڈ خالی نہیں ہو سکتا',
      'passwordLengthError': 'پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے',
      'phoneEmptyError': 'فون نمبر خالی نہیں ہو سکتا',
      'phoneInvalidError': 'ایک درست فون نمبر درج کریں',
      'cityError': 'شہر خالی نہیں ہو سکتا',
    },
  };

  // City translations
  final Map<String, List<String>> _cities = {
    'en': [
      'Karachi', 'Lahore', 'Islamabad', 'Rawalpindi', 'Faisalabad', 'Peshawar', 'Quetta', 'Multan', 'Sialkot',
      'Gujranwala', 'Hyderabad', 'Sukkur', 'Bahawalpur', 'Sargodha', 'Mardan', 'Abbottabad', 'Larkana',
      'Sheikhupura', 'Jhang', 'Mirpur'
    ],
    'ur': [
      'کراچی', 'لاہور', 'اسلام آباد', 'راولپنڈی', 'فیصل آباد', 'پشاور', 'کوئٹہ', 'ملتان', 'سیالکوٹ',
      'گوجرانوالہ', 'حیدرآباد', 'سکھر', 'بہاولپور', 'سرگودھا', 'مردان', 'ایبٹ آباد', 'لاڑکانہ',
      'شیخوپورہ', 'جھنگ', 'میرپور'
    ],
  };

  String _translate(String key, String language, [Map<String, String>? replacements]) {
    String text = _translations[language]?[key] ?? key;
    if (replacements != null) {
      replacements.forEach((k, v) => text = text.replaceAll('{$k}', v));
    }
    return text;
  }

  Future<void> registerUser(String name, String email, String password, String phoneNumber, String city) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore ref = FirebaseFirestore.instance;
    auth.setLanguageCode('en');
    try {
      setState(() {
        _isLoading = true;
      });
      print("Starting registration: ${DateTime.now()}");
      final UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? user = userCredential.user;
      if (user != null) {
        // Store English city name in Firestore
        final cityIndex = _cities['ur']!.indexOf(city);
        final cityToStore = cityIndex >= 0 ? _cities['en']![cityIndex] : city;
        await ref.collection('Customers').doc(user.uid).set({
          'uid': user.uid,
          'name': name.trim(),
          'email': email.trim(),
          'phonenumber': phoneNumber.trim(),
          'city': cityToStore.trim(),
        });
        print("Registration successful: ${DateTime.now()}");
        Fluttertoast.showToast(msg: _translate('successfullyRegistered', Provider.of<LanguageProvider>(context, listen: false).language));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Homescreen()),
          (route) => false,
        );
      }
    } catch (error) {
      print("Registration error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_translate('registrationFailed', Provider.of<LanguageProvider>(context, listen: false).language, {'error': error.toString()})),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _validateAndRegister() {
    if (_formKey.currentState!.validate()) {
      registerUser(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
        _phoneController.text,
        _cityController.text,
      );
    } else {
      print("Form validation failed");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final cities = _cities[isUrdu ? 'ur' : 'en']!;

    print("Building Registration screen");

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00A86B), Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          _translate('customerRegistration', language),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
          ),
          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
        ),
        centerTitle: true,
        
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: isUrdu ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                // Profile Image Section
                Center(
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: Duration(milliseconds: 500),
                    child: Consumer<CustomerImageProvider>(
                      builder: (context, provider, child) {
                        print("Building profile image section");
                        return Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
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
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipOval(
                                child: provider.image != null
                                    ? Image.file(
                                        provider.image!,
                                        width: 160,
                                        height: 160,
                                        fit: BoxFit.cover,
                                      )
                                    : Icon(
                                        Icons.person,
                                        size: 100,
                                        color: Colors.white,
                                      ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: GestureDetector(
                                  onTap: provider.pickImage,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 20,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Color(0xFF00A86B),
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // Header Text
                Text(
                  _translate('createAccount', language),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                  ),
                  textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                ),
                SizedBox(height: 10),
                Text(
                  _translate('fillDetails', language),
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor.withOpacity(0.7),
                    fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                  ),
                  textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                ),
                SizedBox(height: 20),
                // Form Fields
                TextFieldWidget(
                  hint: _translate('fullNameHint', language),
                  icon: Icons.person,
                  controller: _nameController,
                  keyboardtype: TextInputType.text,
                  textColor: textColor,
                  isDark: isDark,
                  isUrdu: isUrdu,
                  validator: (value) => value!.isEmpty ? _translate('fullNameError', language) : null,
                ),
                SizedBox(height: 16),
                TextFieldWidget(
                  hint: _translate('emailHint', language),
                  icon: Icons.email,
                  controller: _emailController,
                  keyboardtype: TextInputType.emailAddress,
                  textColor: textColor,
                  isDark: isDark,
                  isUrdu: isUrdu,
                  validator: (value) {
                    if (value!.isEmpty) return _translate('emailEmptyError', language);
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return _translate('emailInvalidError', language);
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Consumer<CustomerImageProvider>(
                  builder: (context, provider, _) {
                    return TextFieldWidget(
                      hint: _translate('passwordHint', language),
                      icon: Icons.lock,
                      controller: _passwordController,
                      keyboardtype: TextInputType.text,
                      obscureText: !provider.isPasswordVisible,
                      showSuffixIcon: true,
                      onSuffixTap: provider.toggleVisibility,
                      textColor: textColor,
                      isDark: isDark,
                      isUrdu: isUrdu,
                      validator: (value) {
                        if (value!.isEmpty) return _translate('passwordEmptyError', language);
                        if (value.length < 6) return _translate('passwordLengthError', language);
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(height: 16),
                TextFieldWidget(
                  hint: _translate('phoneNumberHint', language),
                  icon: Icons.phone,
                  controller: _phoneController,
                  keyboardtype: TextInputType.phone,
                  textColor: textColor,
                  isDark: isDark,
                  isUrdu: isUrdu,
                  validator: (value) {
                    if (value!.isEmpty) return _translate('phoneEmptyError', language);
                    if (!RegExp(r'^\d{10,15}$').hasMatch(value)) return _translate('phoneInvalidError', language);
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Container(
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
                  child: DropdownButtonFormField<String>(
                    value: _cityController.text.isEmpty ? null : _cityController.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.location_city,
                        color: _cityController.text.isNotEmpty ? Color(0xFF00A86B) : Colors.grey,
                      ),
                      hintText: _translate('cityHint', language),
                      labelText: _translate('cityHint', language),
                      labelStyle: TextStyle(
                        color: _cityController.text.isNotEmpty ? Color(0xFF00A86B) : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      filled: true,
                      fillColor: Colors.transparent,
                      hintTextDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                    ),
                    items: cities.map((String city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(
                          city,
                          style: TextStyle(
                            color: textColor,
                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                          ),
                          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _cityController.text = value ?? '';
                      });
                    },
                    validator: (value) => value == null || value.isEmpty ? _translate('cityError', language) : null,
                  ),
                ),
                SizedBox(height: 24),
                // Continue Button
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: Duration(milliseconds: 500),
                  child: GestureDetector(
                    onTap: _isLoading ? null : _validateAndRegister,
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
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _translate('continueButton', language),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                                ),
                                textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldWidget extends StatefulWidget {
  final String hint;
  final IconData? icon;
  final bool showSuffixIcon;
  final TextInputType keyboardtype;
  final TextEditingController controller;
  final bool obscureText;
  final Function()? onSuffixTap;
  final String? Function(String?) validator;
  final Color textColor;
  final bool isDark;
  final bool isUrdu;

  const TextFieldWidget({
    required this.hint,
    this.icon,
    this.showSuffixIcon = false,
    required this.keyboardtype,
    required this.controller,
    this.obscureText = false,
    this.onSuffixTap,
    required this.validator,
    required this.textColor,
    required this.isDark,
    required this.isUrdu,
    super.key,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
      print("TextField '${widget.hint}' focus: ${_focusNode.hasFocus}");
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Building TextFieldWidget: ${widget.hint}");
    return Container(
      decoration: BoxDecoration(
        color: widget.isDark ? Colors.grey[850] : Colors.white,
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
        controller: widget.controller,
        keyboardType: widget.keyboardtype,
        obscureText: widget.obscureText,
        focusNode: _focusNode,
        style: TextStyle(
          color: widget.textColor,
          fontFamily: widget.isUrdu ? 'NotoNastaliqUrdu' : null,
        ),
        textDirection: widget.isUrdu ? TextDirection.rtl : TextDirection.ltr,
        decoration: InputDecoration(
          prefixIcon: widget.icon != null
              ? Icon(
                  widget.icon,
                  color: _focusNode.hasFocus ? Color(0xFF00A86B) : Colors.grey,
                )
              : null,
          suffixIcon: widget.showSuffixIcon
              ? GestureDetector(
                  onTap: widget.onSuffixTap,
                  child: Icon(
                    widget.obscureText ? Icons.visibility_off : Icons.visibility,
                    color: _focusNode.hasFocus ? Color(0xFF00A86B) : Colors.grey,
                  ),
                )
              : null,
          hintText: widget.hint,
          labelText: widget.hint,
          labelStyle: TextStyle(
            color: _focusNode.hasFocus ? Color(0xFF00A86B) : Colors.grey,
            fontWeight: FontWeight.bold,
            fontFamily: widget.isUrdu ? 'NotoNastaliqUrdu' : null,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: Colors.transparent,
          hintTextDirection: widget.isUrdu ? TextDirection.rtl : TextDirection.ltr,
        ),
        validator: widget.validator,
      ),
    );
  }
}