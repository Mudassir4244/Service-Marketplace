
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:servable/Screens/loginscreen.dart';
import 'package:servable/Screens/worker_detail.dart';
import 'package:servable/aminpanel/adminpanel.dart';
import 'package:servable/customer_view/allworker.dart';
import 'package:servable/customer_view/customer_profilescreen.dart';
import 'package:servable/privacy/about.dart';
import 'package:servable/privacy/helpandsupport.dart';
import 'package:servable/privacy/privacy.dart';
import 'package:servable/privacy/reportproblem.dart';
import 'package:servable/privacy/subscription.dart';
import 'package:servable/security/app_security.dart';
import 'package:servable/theme_provider/themeprovider.dart';
import 'package:servable/updation/profile_update.dart';



class setting extends StatefulWidget {
  const setting({super.key});

  @override
  State<setting> createState() => _SettingsState();
}

class _SettingsState extends State<setting> {
  final TextEditingController adminController = TextEditingController();

  // Embedded translations
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'settings': 'Settings',
      'account': 'Account',
      'editProfile': 'Edit Profile',
      'security': 'Security',
      'notifications': 'Notifications',
      'privacy': 'Privacy',
      'supportAndAbout': 'Support and About',
      'subscriptions': 'Subscriptions',
      'helpAndSupport': 'Help and Support',
      'admin': 'Admin',
      'about': 'About',
      'actions': 'Actions',
      'reportProblem': 'Report a Problem',
      'addAccount': 'Add Account',
      'logout': 'Logout',
      'logoutConfirm': 'Do you want to Logout?',
      'logoutSuccess': 'Logout Successfully',
      'logoutFailed': 'Logout Failed: ',
      'adminPassword': 'Enter Admin Password',
      'passwordHint': 'Enter password',
      'adminLabel': 'Admin',
      'cancel': 'Cancel',
      'submit': 'Submit',
      'welcomeAdmin': 'Welcome to the admin screen',
      'incorrectPassword': 'Incorrect password',
      'notificationsNotImplemented': 'Notification settings not implemented',
      'privacyNotImplemented': 'Privacy settings not implemented',
      'subscriptionsNotImplemented': 'Subscriptions not implemented',
      'helpNotImplemented': 'Help and Support not implemented',
      'aboutNotImplemented': 'About not implemented',
      'reportNotImplemented': 'Report a Problem not implemented',
      'addAccountNotImplemented': 'Add Account not implemented',
      'yes': 'Yes',
      'no': 'No',
      'profileName': 'Profile Name',
      'theme': 'Theme',
      'profile': 'Profile',
      'language': 'Language',
    },
    'ur': {
      'settings': 'ترتیبات',
      'account': 'اکاؤنٹ',
      'editProfile': 'پروفائل ترمیم کریں',
      'security': 'سیکیورٹی',
      'notifications': 'اطلاعات',
      'privacy': 'رازداری',
      'supportAndAbout': 'سپورٹ اور کے بارے میں',
      'subscriptions': 'سبسکرپشنز',
      'helpAndSupport': 'مدد اور سپورٹ',
      'admin': 'ایڈمن',
      'about': 'کے بارے میں',
      'actions': 'عمل',
      'reportProblem': 'مسئلہ رپورٹ کریں',
      'addAccount': 'اکاؤنٹ شامل کریں',
      'logout': 'لاگ آؤٹ',
      'logoutConfirm': 'کیا آپ لاگ آؤٹ کرنا چاہتے ہیں؟',
      'logoutSuccess': 'کامیابی سے لاگ آؤٹ ہو گیا',
      'logoutFailed': 'لاگ آؤٹ ناکام: ',
      'adminPassword': 'ایڈمن پاس ورڈ درج کریں',
      'passwordHint': 'پاس ورڈ درج کریں',
      'adminLabel': 'ایڈمن',
      'cancel': 'منسوخ کریں',
      'submit': 'جمع کریں',
      'welcomeAdmin': 'ایڈمن اسکرین میں خوش آمدید',
      'incorrectPassword': 'غلط پاس ورڈ',
      'notificationsNotImplemented': 'اطلاعات کی ترتیبات نافذ نہیں کی گئیں',
      'privacyNotImplemented': 'رازداری کی ترتیبات نافذ نہیں کی گئیں',
      'subscriptionsNotImplemented': 'سبسکرپشنز نافذ نہیں کی گئیں',
      'helpNotImplemented': 'مدد اور سپورٹ نافذ نہیں کی گئی',
      'aboutNotImplemented': 'کے بارے میں نافذ نہیں کیا گیا',
      'reportNotImplemented': 'مسئلہ رپورٹ نافذ نہیں کیا گیا',
      'addAccountNotImplemented': 'اکاؤنٹ شامل کرنا نافذ نہیں کیا گیا',
      'yes': 'ہاں',
      'no': 'نہیں',
      'profileName': 'پروفائل کا نام',
      'theme': 'تھیم',
      'profile': 'پروفائل',
      'language': 'زبان',
    },
  };

  String _translate(String key, String language) {
    return _translations[language]?[key] ?? key;
  }

  void logout(BuildContext context, String language) {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Loginpage()),
        (route) => false,
      );
      Fluttertoast.showToast(msg: _translate('logoutSuccess', language));
    }).catchError((e) {
      Fluttertoast.showToast(msg: "${_translate('logoutFailed', language)}$e");
    });
  }

  @override
  void dispose() {
    adminController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final customerProvider = Provider.of<CustomerProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final isUrdu = languageProvider.isUrdu;
    final language = languageProvider.language;
    final bgColor = isDark ? Colors.black : const Color(0xFFF1FCF7);
    final textColor = isDark ? Colors.white : Colors.black87;

    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 4,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF00A86B), Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: Text(
            _translate('settings', language),
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
       
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: isUrdu ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
            children: [
              _buildSectionHeader(_translate('account', language), textColor, isUrdu),
              _buildSettingItem(
                icon: Icons.person_outline,
                title: _translate('editProfile', language),
                textColor: textColor,
                isDark: isDark,
                isUrdu: isUrdu,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileUpdate()),
                  );
                },
              ),
              _buildSettingItem(
                icon: Icons.security_sharp,
                title: _translate('security', language),
                textColor: textColor,
                isDark: isDark,
                isUrdu: isUrdu,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SecurityScreen()));
                },
              ),
              // _buildSettingItem(
              //   icon: Icons.notifications_outlined,
              //   title: _translate('notifications', language),
              //   textColor: textColor,
              //   isDark: isDark,
              //   isUrdu: isUrdu,
              //   onTap: () {
              //     Fluttertoast.showToast(msg: _translate('notificationsNotImplemented', language));
              //   },
              // ),
              _buildSettingItem(
                icon: Icons.lock_outline,
                title: _translate('privacy', language),
                textColor: textColor,
                isDark: isDark,
                isUrdu: isUrdu,
                onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>PrivacyScreen()));
                },
              ),
              _buildSectionHeader(_translate('supportAndAbout', language), textColor, isUrdu),
              // _buildSettingItem(
              //   icon: Icons.payment,
              //   title: _translate('subscriptions', language),
              //   textColor: textColor,
              //   isDark: isDark,
              //   isUrdu: isUrdu,
              //   onTap: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (context)=>SubscriptionScreen()));
              //   },
              // ),
              _buildSettingItem(
                icon: Icons.help_outline_rounded,
                title: _translate('helpAndSupport', language),
                textColor: textColor,
                isDark: isDark,
                isUrdu: isUrdu,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HelpSupportScreen()));
                },
              ),
              _buildSettingItem(
                icon: Icons.admin_panel_settings_outlined,
                title: _translate('admin', language),
                textColor: textColor,
                isDark: isDark,
                isUrdu: isUrdu,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
                        title: Text(
                          _translate('adminPassword', language),
                          style: TextStyle(
                            color: textColor,
                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                          ),
                          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        ),
                        content: TextField(
                          controller: adminController,
                          obscureText: true,
                          style: TextStyle(
                            color: textColor,
                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                          ),
                          decoration: InputDecoration(
                            hintText: _translate('passwordHint', language),
                            hintStyle: TextStyle(
                              color: isDark ? Colors.white54 : Colors.black54,
                              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                            ),
                            labelText: _translate('adminLabel', language),
                            labelStyle: TextStyle(
                              color: textColor,
                              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                            ),
                            filled: true,
                            fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              adminController.clear();
                              Navigator.pop(context);
                            },
                            child: Text(
                              _translate('cancel', language),
                              style: TextStyle(color: Colors.grey),
                              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF00A86B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              const String adminPassword = '1234567890';
                              if (adminController.text == adminPassword) {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Adminpanel()),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      _translate('welcomeAdmin', language),
                                      textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                    ),
                                    backgroundColor: Color(0xFF00A86B),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      _translate('incorrectPassword', language),
                                      textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                              adminController.clear();
                            },
                            child: Text(
                              _translate('submit', language),
                              style: TextStyle(color: Colors.white),
                              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              _buildSettingItem(
                icon: Icons.info_outline_rounded,
                title: _translate('about', language),
                textColor: textColor,
                isDark: isDark,
                isUrdu: isUrdu,
                onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutScreen()));
                },
              ),
              _buildSectionHeader(_translate('actions', language), textColor, isUrdu),
              _buildSettingItem(
                icon: Icons.report_problem_outlined,
                title: _translate('reportProblem', language),
                textColor: textColor,
                isDark: isDark,
                isUrdu: isUrdu,
                onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportProblemScreen()));
                },
              ),
              // _buildSettingItem(
              //   icon: Icons.person_add_alt_1_outlined,
              //   title: _translate('addAccount', language),
              //   textColor: textColor,
              //   isDark: isDark,
              //   isUrdu: isUrdu,
              //   onTap: () {
              //     Fluttertoast.showToast(msg: _translate('addAccountNotImplemented', language));
              //   },
              // ),
              _buildSettingItem(
                icon: Icons.logout,
                title: _translate('logout', language),
                textColor: textColor,
                isDark: isDark,
                isUrdu: isUrdu,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
                        title: Text(
                          _translate('logoutConfirm', language),
                          style: TextStyle(
                            color: textColor,
                            fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                          ),
                          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              _translate('no', language),
                              style: TextStyle(color: Colors.grey),
                              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF00A86B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              logout(context, language);
                              Navigator.pop(context);
                            },
                            child: Text(
                              _translate('yes', language),
                              style: TextStyle(color: Colors.white),
                              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color textColor, bool isUrdu) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: isUrdu ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
            ),
            textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
          ),
          Divider(color: textColor.withOpacity(0.2)),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required Color textColor,
    required bool isDark,
    required bool isUrdu,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 300),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: isDark ? Colors.grey[850] : Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Icon(
                    icon,
                    color: Color(0xFF00A86B),
                    size: 24,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        color: textColor,
                        fontWeight: FontWeight.w500,
                        fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
                      ),
                      textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: textColor.withOpacity(0.5),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    final isUrdu = Provider.of<LanguageProvider>(context).isUrdu;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textColor,
                letterSpacing: 1.5,
                fontFamily: isUrdu ? 'NotoNastaliqUrdu' : null,
              ),
              textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
            ),
            Spacer(),
            Icon(
              icon,
              color: textColor,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}