
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/categorychoice.dart';
import 'package:servable/Screens/choice.dart';
import 'package:servable/customer_view/homescreen.dart';
import 'package:servable/theme_provider/themeprovider.dart';

class LanguageProvider with ChangeNotifier {
  String _language = 'en';

  String get language => _language;
  bool get isUrdu => _language == 'ur';

  void toggleLanguage() {
    _language = _language == 'en' ? 'ur' : 'en';
    notifyListeners();
  }
}

class WorkerImagePickerProvider with ChangeNotifier {
  bool isPasswordVisible = false;
  List<Map<String, dynamic>> _selectedCategories = [];
  File? _image;
  String _fullName = '';
  String _email = '';
  String _password = '';
  String _phoneNumber = '';
  String _city = '';
  String _experience = '';
  final ImagePicker _imagePicker = ImagePicker();

  List<Map<String, dynamic>> get selectedCategories => _selectedCategories;
  File? get image => _image;
  String get fullName => _fullName;
  String get email => _email;
  String get password => _password;
  String get phoneNumber => _phoneNumber;
  String get city => _city;
  String get experience => _experience;

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

  void setSelectedCategories(List<Map<String, dynamic>> categories) {
    _selectedCategories = categories;
    notifyListeners();
  }

  void removeCategoryAtIndex(int index) {
    if (index >= 0 && index < _selectedCategories.length) {
      _selectedCategories.removeAt(index);
      notifyListeners();
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void updateFullName(String value) {
    _fullName = value;
    notifyListeners();
    print("Provider updated: fullName = $value");
  }

  void updateEmail(String value) {
    _email = value;
    notifyListeners();
    print("Provider updated: email = $value");
  }

  void updatePassword(String value) {
    _password = value;
    notifyListeners();
    print("Provider updated: password = $value");
  }

  void updatePhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
    print("Provider updated: phoneNumber = $value");
  }

  void updateCity(String value) {
    _city = value;
    notifyListeners();
    print("Provider updated: city = $value");
  }

  void updateExperience(String value) {
    _experience = value;
    notifyListeners();
    print("Provider updated: experience = $value");
  }
}

class WorkerDetail extends StatefulWidget {
  final List<Map<String, dynamic>>? selectedCategories;

  const WorkerDetail({super.key, this.selectedCategories});

  @override
  State<WorkerDetail> createState() => _WorkerDetailState();
}

class _WorkerDetailState extends State<WorkerDetail> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController fullname_controller;
  late TextEditingController email_controller;
  late TextEditingController password_controller;
  late TextEditingController phone_controller;
  late TextEditingController cityController;
  late TextEditingController experienceController;
  bool _isLoading = false;

  // Embedded translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'workerRegistrationTitle': 'Worker Registration',
      'createWorkerAccount': 'Create Your Worker Account',
      'fillDetails': 'Fill in your details to register',
      'fullNameHint': 'Full Name',
      'emailHint': 'Email',
      'passwordHint': 'Password',
      'phoneNumberHint': 'Phone Number',
      'cityHint': 'City',
      'categoryHint': 'Category',
      'selectCategoryHint': 'Select category',
      'noCategoriesSelected': 'No categories selected',
      'pleaseSelectCategory': 'Please select at least one category',
      'experienceHint': 'Experience',
      'continueButton': 'Continue',
      'successfullyRegistered': 'Successfully registered as Worker',
      'registrationFailed': 'Registration Failed: {error}',
      'fullNameError': 'Please enter your full name',
      'emailEmptyError': 'Please enter your email',
      'emailInvalidError': 'Please enter a valid email',
      'passwordEmptyError': 'Please enter your password',
      'passwordLengthError': 'Password must be at least 6 characters',
      'phoneEmptyError': 'Please enter your phone number',
      'phoneInvalidError': 'Enter a valid phone number',
      'cityError': 'Please select your city',
      'experienceError': 'Please enter your experience',
      'languageToggleTooltip': 'Switch to Urdu',
    },
    'ur': {
      'workerRegistrationTitle': 'ورکر رجسٹریشن',
      'createWorkerAccount': 'اپنا ورکر اکاؤنٹ بنائیں',
      'fillDetails': 'رجسٹریشن کے لیے اپنی تفصیلات پُر کریں',
      'fullNameHint': 'مکمل نام',
      'emailHint': 'ای میل',
      'passwordHint': 'پاس ورڈ',
      'phoneNumberHint': 'فون نمبر',
      'cityHint': 'شہر',
      'categoryHint': 'زمرہ',
      'selectCategoryHint': 'زمرہ منتخب کریں',
      'noCategoriesSelected': 'کوئی زمرہ منتخب نہیں کیا گیا',
      'pleaseSelectCategory': 'براہ کرم کم از کم ایک زمرہ منتخب کریں',
      'experienceHint': 'تجربہ',
      'continueButton': 'جاری رکھیں',
      'successfullyRegistered': 'ورکر کے طور پر کامیابی سے رجسٹرڈ',
      'registrationFailed': 'رجسٹریشن ناکام: {error}',
      'fullNameError': 'براہ کرم اپنا مکمل نام درج کریں',
      'emailEmptyError': 'براہ کرم اپنا ای میل درج کریں',
      'emailInvalidError': 'براہ کرم ایک درست ای میل درج کریں',
      'passwordEmptyError': 'براہ کرم اپنا پاس ورڈ درج کریں',
      'passwordLengthError': 'پاس ورڈ کم از کم 6 حروف کا ہونا چاہیے',
      'phoneEmptyError': 'براہ کرم اپنا فون نمبر درج کریں',
      'phoneInvalidError': 'ایک درست فون نمبر درج کریں',
      'cityError': 'براہ کرم اپنا شہر منتخب کریں',
      'experienceError': 'براہ کرم اپنا تجربہ درج کریں',
      'languageToggleTooltip': 'Switch to English',
    },
  };

  // City lists
  final List<String> _citiesEn = [
    'Karachi', 'Lahore', 'Islamabad', 'Rawalpindi', 'Faisalabad', 'Peshawar', 'Quetta', 'Multan', 'Sialkot',
    'Gujranwala', 'Hyderabad', 'Sukkur', 'Bahawalpur', 'Sargodha', 'Mardan', 'Abbottabad', 'Larkana',
    'Sheikhupura', 'Jhang', 'Mirpur'
  ];
  final List<String> _citiesUr = [
    'کراچی', 'لاہور', 'اسلام آباد', 'راولپنڈی', 'فیصل آباد', 'پشاور', 'کوئٹہ', 'ملتان', 'سیالکوٹ',
    'گوجرانوالہ', 'حیدرآباد', 'سکھر', 'بہاولپور', 'سرگودھا', 'مردان', 'ایبٹ آباد', 'لاڑکانہ',
    'شیخوپورہ', 'جھنگ', 'میرپور'
  ];

  @override
  void initState() {
    super.initState();
    final workerProvider = Provider.of<WorkerImagePickerProvider>(context, listen: false);
    fullname_controller = TextEditingController(text: workerProvider.fullName);
    email_controller = TextEditingController(text: workerProvider.email);
    password_controller = TextEditingController(text: workerProvider.password);
    phone_controller = TextEditingController(text: workerProvider.phoneNumber);
    cityController = TextEditingController(text: workerProvider.city);
    experienceController = TextEditingController(text: workerProvider.experience);

    if (widget.selectedCategories != null && widget.selectedCategories!.isNotEmpty) {
      workerProvider.setSelectedCategories(widget.selectedCategories!);
    }
  }

  Future<void> addworker(
    String fullname,
    String email,
    String password,
    String phonenumber,
    String city,
    List<String> categories,
    String experience,
  ) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore ref = FirebaseFirestore.instance;
    auth.setLanguageCode('en');
    final language = Provider.of<LanguageProvider>(context, listen: false).language;
    try {
      setState(() {
        _isLoading = true;
      });
      print("Starting worker registration: ${DateTime.now()}");
      final UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? user = userCredential.user;
      if (user != null) {
        await ref.collection('Worker').doc(user.uid).set({
          'uid': user.uid,
          'name': fullname.trim(),
          'email': email.trim(),
          'phonenumber': phonenumber.trim(),
          'categories': categories,
          'experience': experience.trim(),
          'city': city.trim(),
        });
        print("Worker registration successful: ${DateTime.now()}");
        Fluttertoast.showToast(msg: _translations[language]!['successfullyRegistered']!);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Homescreen()),
          (route) => false,
        );
      }
    } catch (error) {
      print("Worker registration error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_translations[language]!['registrationFailed']!.replaceAll('{error}', error.toString())),
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

  @override
  void dispose() {
    fullname_controller.dispose();
    email_controller.dispose();
    password_controller.dispose();
    phone_controller.dispose();
    cityController.dispose();
    experienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final workerProvider = Provider.of<WorkerImagePickerProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final bgColor = isDark ? Colors.black : const Color(0xFFF1FCF7);
    final textColor = isDark ? Colors.white : Colors.black87;
    final screenWidth = MediaQuery.of(context).size.width;
    final language = languageProvider.language;
    final isUrdu = languageProvider.isUrdu;
    final cities = isUrdu ? _citiesUr : _citiesEn;

    fullname_controller.text = workerProvider.fullName;
    email_controller.text = workerProvider.email;
    password_controller.text = workerProvider.password;
    phone_controller.text = workerProvider.phoneNumber;
    cityController.text = workerProvider.city;
    experienceController.text = workerProvider.experience;

    print("Building WorkerDetail screen");

    return SafeArea(
      child: Directionality(
        textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 4,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00A86B), Colors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            title: Text(
              _translations[language]!['workerRegistrationTitle']!,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            // automaticallyImplyLeading: false,
            // leading: IconButton(
            //   onPressed: () {
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => ChoiceScreen()));
            //   },
            //   icon: Icon(Icons.arrow_back),
            // ),
            actions: [
              // IconButton(
              //   onPressed: () {
              //     Provider.of<LanguageProvider>(context, listen: false).toggleLanguage();
              //   },
              //   icon: Icon(Icons.language, color: Colors.white),
              //   tooltip: _translations[language]!['languageToggleTooltip'],
              // ),
            ],
            iconTheme: IconThemeData(color: Colors.white),
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
                    Center(
                      child: AnimatedOpacity(
                        opacity: 1.0,
                        duration: Duration(milliseconds: 500),
                        child: Consumer<WorkerImagePickerProvider>(
                          builder: (context, provider, child) {
                            return Container(
                              width: 160,
                              height: 160,
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
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipOval(
                                    child: workerProvider.image != null
                                        ? Image.file(
                                            workerProvider.image!,
                                            width: 160,
                                            height: 160,
                                            fit: BoxFit.cover,
                                            key: ValueKey(workerProvider.image!.path),
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
                    Text(
                      _translations[language]!['createWorkerAccount']!,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _translations[language]!['fillDetails']!,
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormFieldWidget(
                      hint: _translations[language]!['fullNameHint']!,
                      icon: Icons.person,
                      keyboardType: TextInputType.text,
                      controller: fullname_controller,
                      textColor: textColor,
                      isDark: isDark,
                      isUrdu: isUrdu,
                      validator: (value) => value!.isEmpty ? _translations[language]!['fullNameError'] : null,
                      onChanged: (value) {
                        Provider.of<WorkerImagePickerProvider>(context, listen: false).updateFullName(value);
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormFieldWidget(
                      hint: _translations[language]!['emailHint']!,
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      controller: email_controller,
                      textColor: textColor,
                      isDark: isDark,
                      isUrdu: isUrdu,
                      validator: (value) {
                        if (value!.isEmpty) return _translations[language]!['emailEmptyError'];
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return _translations[language]!['emailInvalidError'];
                        }
                        return null;
                      },
                      onChanged: (value) {
                        Provider.of<WorkerImagePickerProvider>(context, listen: false).updateEmail(value);
                      },
                    ),
                    SizedBox(height: 16),
                    Consumer<WorkerImagePickerProvider>(
                      builder: (context, provider, _) {
                        return TextFormFieldWidget(
                          hint: _translations[language]!['passwordHint']!,
                          icon: Icons.lock,
                          keyboardType: TextInputType.text,
                          controller: password_controller,
                          obscureText: !provider.isPasswordVisible,
                          showSuffixIcon: true,
                          onSuffixTap: provider.togglePasswordVisibility,
                          textColor: textColor,
                          isDark: isDark,
                          isUrdu: isUrdu,
                          validator: (value) {
                            if (value!.isEmpty) return _translations[language]!['passwordEmptyError'];
                            if (value.length < 6) return _translations[language]!['passwordLengthError'];
                            return null;
                          },
                          onChanged: (value) {
                            Provider.of<WorkerImagePickerProvider>(context, listen: false).updatePassword(value);
                          },
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormFieldWidget(
                      hint: _translations[language]!['phoneNumberHint']!,
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      controller: phone_controller,
                      textColor: textColor,
                      isDark: isDark,
                      isUrdu: isUrdu,
                      validator: (value) {
                        if (value!.isEmpty) return _translations[language]!['phoneEmptyError'];
                        if (!RegExp(r'^\d{10,15}$').hasMatch(value)) return _translations[language]!['phoneInvalidError'];
                        return null;
                      },
                      onChanged: (value) {
                        Provider.of<WorkerImagePickerProvider>(context, listen: false).updatePhoneNumber(value);
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
                        value: cityController.text.isEmpty ? null : cityController.text,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.location_city_rounded,
                            color: cityController.text.isNotEmpty ? Color(0xFF00A86B) : Colors.grey,
                          ),
                          hintText: _translations[language]!['cityHint'],
                          labelText: _translations[language]!['cityHint'],
                          labelStyle: TextStyle(
                            color: cityController.text.isNotEmpty ? Color(0xFF00A86B) : Colors.grey,
                            fontWeight: FontWeight.bold,
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
                            value: isUrdu ? _citiesEn[_citiesUr.indexOf(city)] : city,
                            child: Text(
                              city,
                              style: TextStyle(color: textColor),
                              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            cityController.text = value ?? '';
                            Provider.of<WorkerImagePickerProvider>(context, listen: false).updateCity(value ?? '');
                          });
                        },
                        validator: (value) => value == null || value.isEmpty ? _translations[language]!['cityError'] : null,
                      ),
                    ),
                    SizedBox(height: 16),
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 300),
                      child: Container(
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
                        child: Column(
                          crossAxisAlignment: isUrdu ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            InputDecorator(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.list,
                                  color: workerProvider.selectedCategories.isNotEmpty ? Color(0xFF00A86B) : Colors.grey,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () async {
                                    final selectedCategories = await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CategoryChoiceScreen()),
                                    );
                                    if (selectedCategories != null) {
                                      workerProvider.setSelectedCategories(selectedCategories);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF00A86B),
                                      size: 16,
                                    ),
                                  ),
                                ),
                                hintText: _translations[language]!['selectCategoryHint'],
                                labelText: _translations[language]!['categoryHint'],
                                labelStyle: TextStyle(
                                  color: workerProvider.selectedCategories.isNotEmpty ? Color(0xFF00A86B) : Colors.grey,
                                  fontWeight: FontWeight.bold,
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
                              child: workerProvider.selectedCategories.isEmpty
                                  ? Text(
                                      _translations[language]!['noCategoriesSelected']!,
                                      style: TextStyle(color: textColor.withOpacity(0.6)),
                                      textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                    )
                                  : Wrap(
                                      spacing: 8.0,
                                      runSpacing: 4.0,
                                      children: workerProvider.selectedCategories.asMap().entries.map((entry) {
                                        final index = entry.key;
                                        final category = entry.value;
                                        return Chip(
                                          label: Text(
                                            isUrdu ? category['name_ur'] ?? category['name'] : category['name'],
                                            style: TextStyle(color: textColor),
                                            textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                          ),
                                          backgroundColor: isDark ? Colors.grey[700] : Colors.grey[200],
                                          deleteIcon: Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.red,
                                          ),
                                          onDeleted: () {
                                            workerProvider.removeCategoryAtIndex(index);
                                          },
                                        );
                                      }).toList(),
                                    ),
                            ),
                            if (workerProvider.selectedCategories.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  _translations[language]!['pleaseSelectCategory']!,
                                  style: TextStyle(color: Colors.red, fontSize: 12),
                                  textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormFieldWidget(
                      hint: _translations[language]!['experienceHint']!,
                      icon: Icons.work,
                      keyboardType: TextInputType.text,
                      controller: experienceController,
                      textColor: textColor,
                      isDark: isDark,
                      isUrdu: isUrdu,
                      validator: (value) => value!.isEmpty ? _translations[language]!['experienceError'] : null,
                      onChanged: (value) {
                        Provider.of<WorkerImagePickerProvider>(context, listen: false).updateExperience(value);
                      },
                    ),
                    SizedBox(height: 24),
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 500),
                      child: GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  List<String> categories = workerProvider.selectedCategories
                                      .map((cat) => cat['name'].toString())
                                      .toList();
                                  addworker(
                                    fullname_controller.text,
                                    email_controller.text,
                                    password_controller.text,
                                    phone_controller.text,
                                    cityController.text,
                                    categories,
                                    experienceController.text,
                                  );
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
                                    _translations[language]!['continueButton']!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
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
        ),
      ),
    );
  }
}

class TextFormFieldWidget extends StatefulWidget {
  final String hint;
  final IconData? icon;
  final bool showSuffixIcon;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool obscureText;
  final Function()? onSuffixTap;
  final String? Function(String?)? validator;
  final Color textColor;
  final bool isDark;
  final bool isUrdu;
  final Function(String)? onChanged;

  const TextFormFieldWidget({
    required this.hint,
    this.icon,
    this.showSuffixIcon = false,
    required this.keyboardType,
    required this.controller,
    this.obscureText = false,
    this.onSuffixTap,
    this.validator,
    required this.textColor,
    required this.isDark,
    required this.isUrdu,
    this.onChanged,
    super.key,
  });

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
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
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        focusNode: _focusNode,
        style: TextStyle(color: widget.textColor, fontFamily: widget.isUrdu ? 'NotoNastaliqUrdu' : null),
        textDirection: widget.isUrdu ? TextDirection.rtl : TextDirection.ltr,
        onChanged: widget.onChanged,
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
          alignLabelWithHint: true,
        ),
        validator: widget.validator,
      ),
    );
  }
}