
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:servable/customer_view/allworker.dart';
import 'package:servable/customer_view/customer_profilescreen.dart';
import 'package:servable/customer_view/services.dart';
import 'package:servable/theme_provider/themeprovider.dart';
// import 'package:servable/updation/categoriesupdation.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({super.key});

  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController cityController;
  late TextEditingController emailController;
  late TextEditingController categoryController;
  late TextEditingController experienceController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final userData = Provider.of<CustomerProvider>(context, listen: false).userData;
    nameController = TextEditingController(text: userData?['name'] ?? '');
    emailController = TextEditingController(text: userData?['email'] ?? '');
    phoneController = TextEditingController(text: userData?['phonenumber'] ?? '');
    cityController = TextEditingController(text: userData?['city'] ?? '');
    
    // ✅ Properly handle both List and String types for 'categories'
    final rawCategories = userData?['categories'];
    categoryController = TextEditingController(
      text: rawCategories is List
          ? rawCategories.join(', ')
          : rawCategories?.toString() ?? '',
    );

    experienceController = TextEditingController(text: userData?['experience'] ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    cityController.dispose();
    emailController.dispose();
    categoryController.dispose();
    experienceController.dispose();
    super.dispose();
  }

  Future<bool> _validateInputs() async {
    if (nameController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: 'Name cannot be empty');
      return false;
    }
    if (phoneController.text.trim().isNotEmpty &&
        !RegExp(r'^\+?\d{10,15}$').hasMatch(phoneController.text.trim())) {
      Fluttertoast.showToast(msg: 'Invalid phone number');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    final bgColor = isDark ? Colors.black : const Color(0xFFF1FCF7);
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
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
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: nameController,
                label: 'Name',
                textColor: textColor,
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: emailController,
                label: 'Email',
                textColor: textColor,
                isDark: isDark,
                enabled: false,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: phoneController,
                label: 'Phone Number',
                textColor: textColor,
                isDark: isDark,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: cityController,
                label: 'City',
                textColor: textColor,
                isDark: isDark,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: categoryController,
                label: 'Categories (comma-separated)',
                textColor: textColor,
                isDark: isDark,
              ),
              // TextField(
              //   controller: categoryController,
              //   decoration: InputDecoration(
              //     suffixIcon: IconButton(
              //       onPressed: (){
              //         Navigator.push(context, MaterialPageRoute(builder: (context)=>categoriesupdation()));
              //       }
              //       , icon: Icon(Icons.arrow_forward_ios_outlined),)
              //   ),
              // ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: experienceController,
                label: 'Experience',
                textColor: textColor,
                isDark: isDark,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF00A86B)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    elevation: MaterialStateProperty.all<double>(6),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (!(await _validateInputs())) return;

                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            final categories = categoryController.text
                                .split(',')
                                .map((e) => e.trim())
                                .where((e) => e.isNotEmpty)
                                .toList();
                           
                            await provider.updateField('name', nameController.text.trim());
                            await provider.updateField('email', emailController.text.trim());
                            await provider.updateField('phonenumber', phoneController.text.trim());
                            await provider.updateField('city', cityController.text.trim());
                            await provider.updateField('categories', categories.join(', '));
                            await provider.updateField('experience', experienceController.text.trim());

                             Fluttertoast.showToast(msg: 'Profile Updated Successfully');
                            // Navigator.pop(context);
                          } catch (e) {
                            Fluttertoast.showToast(msg: 'Failed to update profile: $e');
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                  child: _isLoading
                      ? CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                      : const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required Color textColor,
    required bool isDark,
    bool enabled = true,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
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
